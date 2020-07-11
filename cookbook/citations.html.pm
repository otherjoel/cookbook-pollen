#lang pollen

◊define-meta[files (("citations.rkt" "Source code for citation/bibliography tag functions"))]

◊title{Citations and Bibliographies}

Suppose you want to be able to define some source, and easily reference it in your document. You
also want to produce a list of all such sources — a bibliography.

We’ll show how to implement a simple system for this.

◊section{Challenge: tags that need to talk to each other}

This is an “interesting” problem to work on because 1) the solution depends so much on the nature
and structure of your project, and 2) the tag functions need to be aware of each other somehow.

Consider the following example Pollen markup:

◊codeblock|{
#lang pollen

Paragraphs are important. ◊cite[1]

◊define-citation[1]{Chicago Manual of Style, 15th edition}

◊insert-bibliography[]
}|

In order for the ◊tag{cite} tag to produce the right output, it needs to be able to access
information in the ◊tag{define-citation} tag that has the same number. And the
◊tag{insert-bibliography} tag needs to do the same for ◊em{all} the ◊tag{define-citation} tags.

Also notice that our ◊tag{define-citation} comes ◊em{after} the ◊tag{cite} tag that references it.
Remember: the book is a program. This Pollen markup isn’t just a static document; it’s a series of
expressions that are evaluated in order. How is the ◊code{cite} tag function supposed to access the
output of a ◊code{define-citation} function call that hasn’t even been reached yet?

◊section{The Tree of Knowledge}

At the point a tag function is called, it “knows” about two things:

◊ol{

◊li{Anything ◊code{provide}d by ◊code{pollen.rkt}}

◊li{Its own attributes and elements}

}

So whenever you find yourself trying to create a tag function that doesn’t simply transform its own
attributes and elements — i.e., that needs to draw on information outside itself — you really have
two options:

◊ol{

◊li{Construct (and maintain and provide) the information you need in ◊code{pollen.rkt}}

◊li{Defer processing until a later tag function that can see more of the doc (usually ◊code{root})}

}

Both of these approaches are valid and idiomatic. The first is simpler, and suited to a project
where the same information is used across multiple Pollen sources. But sometimes it isn’t an option;
sometimes you the information you need can only be found elsewhere in the same document. That’s when
the second approach is needed.
