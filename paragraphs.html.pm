#lang pollen

◊title{Paragraphs}

Paragraphs don’t get marked up for you automatically: you have to decide how you want this handled.

The most common way: do it in your ◊code{root} function using a call to ◊code{decode} or
◊code{decode-elements} and passing it the ◊code{decode-paragraphs} function: ◊tooltip{The relevant
explainer in the Pollen docs is 
◊link["https://docs.racket-lang.org/pollen/third-tutorial.html#%28part._.Decoding_markup_with_a_root_tag_function%29"]{part
7.7}.}

◊codeblock{
#lang pollen

(require pollen/decode)

(define (root . elements)
  `(main ,@(decode-elements elements 
                            #:txexpr-elements-proc decode-paragraphs
                            #:exclude-tags '(pre))))
}

Note that you can exclude automatic paragraph wrapping within certain tags by supplying a list of
tags in the ◊code{#:exclude-tags} argument. The ◊code{pre} tag is commonly excluded this way since
it is often used for code samples.

◊section{Hard-wrapped paragraphs}

Using the approach above, you will find that any line breaks within your paragraphs get converted to
◊code{br} tags, making them equivalent to hard line breaks in the rendered HTML.

This is because, by default, ◊code{decode-paragraphs} function calls ◊code{decode-linebreaks} without
specifying what to substitute for any line breaks it finds. And ◊code{decode-linebreaks} in turn
defaults to the ◊code{br} tag.

You can change this behavior by wrapping ◊code{decode-linebreaks} in your own helper function that
specifies a different substitution, then passing this helper function to ◊code{decode-elements}:

◊codeblock{
#lang pollen

(require pollen/decode)

◊mark{
(define (hardwrapped-grafs xs)
  (define (newline-to-space xs)
    (decode-linebreaks xs " "))
  (decode-paragraphs xs #:linebreak-proc newline-to-space))}

(define (root . elements)
  `(main ,@(decode-elements elements 
                            ◊mark{#:txexpr-elements-proc hardwrapped-grafs}
                            #:exclude-tags '(pre))))
}

The above code converts single line breaks to space characters instead of converting them to
◊code{br} tags, so lines that are hard-wrapped in the Pollen source file become soft-wrapped in
the HTML output.

◊section{Why do I sometimes not get a ◊code{<p>} tag in my HTML output?}

The ◊code{decode-paragraphs} function determines which elements to wrap inside a paragraph block by
finding those that are either separated by a double newline, or adjacent to block-level elements. So
if your document contains only a single implicit paragraph, it will have neither of those things. To
guarantee that ◊code{decode-paragraphs} wraps everything in at least a single paragraph tag, you
must use the ◊code{#:force? #t} option:

◊codeblock{
#lang pollen

(require pollen/decode)

(define (hardwrapped-grafs xs)
  (define (newline-to-space xs)
    (decode-linebreaks xs " "))
  (decode-paragraphs xs #:linebreak-proc newline-to-space))

(define (root . elements)
  `(main ,@(decode-elements elements 
                            #:txexpr-elements-proc hardwrapped-grafs
                            #:exclude-tags '(pre))))
                            ◊mark{#:force? #t})))
}


