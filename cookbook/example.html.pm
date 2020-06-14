#lang pollen

◊define-citation['zmuse]{◊link["http://google.com"]{◊i{Muse in the Machine}, David Gelernter}}

◊define-citation['racket]{◊i{Racket Reference}, pp. 3–5}

This is our example. If you want to know how we did it, read on. A parameter that enables or disables printing of values that have no readable form (using the default reader), including structures that have a custom-write procedure (see prop:custom-write), but not including uninterned symbols and unreadable symbols (which print the same as interned symbols).◊cite['zmuse]

We’ll need some constructs first:

◊codeblock{
(define x "Hello") ; Told ya

(if #t "yes" "no")
}

This is a definition.

◊(insert-bibliography)