#lang pollen

◊(define-meta files '(("tooltips.css.pp" . "CSS styles for tooltips")))

◊title{Tooltips}

The book ◊link["https://beautifulracket.com"]{◊i{Beautiful Racket}}, which you should read and buy,
and which is published with Pollen, includes “tooltips” like the one at the end of this
sentence.◊tooltip{I asked Matthew for (and he very readily gave) permission to explain his tooltip
design. Thanks Matthew!}

This tooltip tag function takes one of the most common, basic forms of tag function: you take in
some inputs and emit a single X-expression that translates directly into HTML.

We will apply the ◊xref["htdpm"]{Pollen markup design recipe}.

◊section{What are we aiming for?}

We want to add tooltips to our Pollen documents using a simple ◊code|{◊tooltip}| tag function, like
this:

◊codeblock|{
#lang pollen

This is my main text.◊tooltip{This is the text of a tooltip}.
}|

◊section{Get it working in HTML and CSS:}

Right-click a tooltip in ◊i{Beautiful Racket} and click ◊samp{Inspect Element} and you will see the
following HTML:

◊codeblock{
<span class="tooltip" 
      onclick="this.classList.toggle('tooltip_visible')">
  &nbsp;+&nbsp;
  <span clas="tooltip-inner">
    The text of the tooltip
  </span>
</span>
}

The markup is simple; the magic is all in the CSS for the three named classes ◊code{tooltip},
◊code{tooltip-inner} and ◊code{tooltip_visible}. You can find this styling by digging further into
the source; I have isolated it into the ◊repofile{tooltips.css.pp} file for you.

◊section{Make an equivalent X-expression}

Change the opening of each tag and the closing tag into a matched set of parentheses:

◊codeblock{
(span class="tooltip"
      onclick="this.classList.toggle('tooltip_visible')"
  &nbsp;+&nbsp;
  (span class="tooltip-inner"
    The text of the tooltip
  )
)
}

Using more parentheses, convert any ◊em{attributes} into a list of pairs:

◊codeblock{
(span ((class "tooltip")
       (onclick "this.classList.toggle('tooltip_visible')"))
  &nbsp;+&nbsp;
  (span ((class "tooltip-inner"))
    The text of the tooltip
  )
)
}

Finally mark any ◊em{element text} as strings, using quotations:

◊codeblock{
(span ((class "tooltip")
       (onclick "this.classList.toggle('tooltip_visible')"))
  "&nbsp;+&nbsp;"
  (span ((class "tooltip-inner"))
    "The text of the tooltip"
  )
)
}

◊section{Make it code}

Open DrRacket and define your X-expression as a variable:

◊codeblock{
#lang racket

(require pollen/template txexpr)

(define test
  '(span ((class "tooltip")
          (onclick "this.classList.toggle('tooltip_visible')"))
         "&nbsp;+&nbsp;"
         (span ((class "tooltip-inner"))
               "The text of the tooltip")))
}

(The ◊code{require} line allows you to use the ◊code{->html} and ◊code{txexpr?} functions.)

Press the ◊samp{Run} button. Then in the bottom area, you can try manipulating your ◊code{test}
variable:

◊codeblock{
◊>>{(txexpr? test)}
#t
◊>>{(->html test)}
"<span class=\"tooltip\" onclick=\"this.classList.toggle('tooltip_visible')\">
&amp;nbsp;+&amp;nbsp;<span class=\"tooltip-inner\">The text of the tooltip
</span></span>"
◊>>{(get-tag test)}
'span
◊>>{(get-attrs test)}
'((class "tooltip") (onclick "this.classList.toggle('tooltip_visible')"))
◊>>{(get-elements test)}
'("&nbsp;+&nbsp;" (span ((class "tooltip-inner")) "The text of the tooltip"))
}

These kinds of tests simply prove that what you have so far is a valid tagged X-expression that you
can convert to HTML and manipulate in various ways.

◊section{Functionize it}

◊codeblock{
#lang racket

(require pollen/template txexpr)

(define ◊mark{(tooltip . elems)}
  ◊mark{`}(span ((class "tooltip")
          (onclick "this.classList.toggle('tooltip_visible')"))
         "&nbsp;+&nbsp;"
         (span ((class "tooltip-inner"))
               ◊mark{,@elems})))
}

Notice the three highlighted changes:

◊ol{
◊li{Instead of defining a variable ◊code{test}, we’re now defining a ◊em{function}, ◊code{tooltip}.
The ◊code{. elems} means “however many arguments are passed to this function, gather them up into a
list named ◊code{elems}.” It is important that our tooltip function be able to accept any number of
arguments, because in the document, a tooltip tag might contain line breaks or further tags, each of
which would become another argument to the tag function.}

◊li{Previously our ◊code{span} started with ◊code{'}, which means ”don’t execute this next bit as code
right now; just treat it as a chunk of data” (that is, shorthand for
◊link["https://docs.racket-lang.org/guide/quote.html"]{◊code{quote}}). Using a backtick ◊code{`}
means the same thing, but allows you to insert bits of code inside the quoted expression (that is,
◊link["https://docs.racket-lang.org/guide/qq.html"]{◊code{quasiquote}}).}

◊li{The second span tag used to contain a string (“the text of the tooltip”). Obviously this is
where we will want to substitute the actual text supplied in the document. So we do so using
◊code{,@elems}. The ◊code{,@} is a bit of syntactic shorthand for ◊code{unquote-splicing}, which
means “insert the following list, but drop its surrounding parentheses and splice it into the
surrounding context.”}
}

Press the ◊samp{Run} button again:

◊codeblock{
◊>>{(tooltip "This is my tooltip")}
'(span
  ((class "tooltip") (onclick "this.classList.toggle('tooltip_visible')"))
  "&nbsp;+&nbsp;"
  (span ((class "tooltip-inner")) "This is my tooltip"))
◊>>{(->html (tooltip "This is my tooltip"))}
"<span class=\"tooltip\" onclick=\"this.classList.toggle('tooltip_visible')\">
&amp;nbsp;+&amp;nbsp;<span class=\"tooltip-inner\">this is my tooltip</span></span>"
}

Congratulations, you now have a working tooltip function. 

◊section{Be a good ◊code{provide}r}

In order to allow your Pollen documents
to use this tag function, add this line to your ◊code{pollen.rkt}:

◊codeblock{
#lang racket

(require pollen/template txexpr)

◊mark{(provide (all-defined-out))}

(define (tooltip . elems)
  `(span ((class "tooltip")
          (onclick "this.classList.toggle('tooltip_visible')"))
         "&nbsp;+&nbsp;"
         (span ((class "tooltip-inner"))
               ,@elems)))
}

You could use ◊code{(provide tooltip)} to provide just the ◊code{tooltip} function. But usually you
have lots of tag functions in your ◊code{pollen.rkt} file, and it would be annoying to type them all
out. Providing ◊code{(all-defined-out)} gives other modules (e.g., your Pollen documents) access to
everything ◊code{define}d in that module.
