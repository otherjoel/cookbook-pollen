#lang pollen

◊define-meta[files (("citations.rkt" "Source code for citation/bibliography tag functions"))]

◊title{Citations and Bibliographies}

You want to be able to define some source, and easily reference it in your document. You also want
to produce a list of all such sources — a bibliography.

We’ll show how to implement a simple system for this.

◊section{Challenge: tags that need to talk to each other}

This is an “interesting” problem to work on because 1) the solution depends so much on the nature
and structure of your project, and 2) the tag functions need to be aware of each other somehow.

For ◊em{this} book, we will keep things simple. We

Consider the following example Pollen markup:

◊codeblock|{
#lang pollen

Paragraphs are important. ◊cite[1]

◊define-citation[1]{Chicago Manual of Style, 15th edition}

◊insert-bibliography[]
}|

In order for the ◊code{◊"◊"cite} tag to produce the right output, it needs to be able to access
information in the ◊code{◊"◊"define-citation} tag that has the same number. And the
◊code{◊"◊"insert-bibliography} tag needs to do the same for ◊em{all} the ◊code{◊"◊"define-citation}
tags.

Also notice that our ◊code{◊"◊"define-citation} comes ◊em{after} the ◊code{◊"◊"cite} tag that
references it. Remember: the book is a program. This Pollen markup isn’t just a static document;
it’s a series of expressions that are evaluated in order. How is the ◊code{cite} tag function
supposed to access the output of a ◊code{define-citation} function call that hasn’t even been
reached yet?
