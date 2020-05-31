#lang pollen

◊title{Tooltips}

The book ◊link["https://beautifulracket.com"]{◊i{Beautiful Racket}}, which is published with Pollen,
includes “tooltips” like the one at the end of this sentence.◊tooltip{You should really
◊link["https://beautifulracket.com/why-you-should-pay.html"]{buy the book}.}

(Prior to Pollen Time #1, I asked Matthew Butterick how he felt about me explaining this to others,
since it comes from his book and is visually unique in my experience. He said sure, go for it.
Thanks Matthew!)

We will apply the ◊link["htdpm.html"]{Pollen markup design recipe}.

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

