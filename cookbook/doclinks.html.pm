#lang pollen

◊(define-meta published "2020-07-19")
◊(define-meta updated "2022-01-22 12:15:00")

◊(define-meta files (("doclinks.rkt" "Source code for tag functions described here")

                     ("doclinks.css.pp" "CSS styles for Racket doc links")))

◊title{Automatic Racket documentation links}

If you’ve read any Racket documentation at all, you’ve seen how, in every block of example code,
each function name links directly to the documentation for that function. This is a feature of
◊link["https://docs.racket-lang.org/scribble/index.html"]{Scribble}, the Racket DSL for creating
documentation. Scribble exposes this capability so that we can take advantage of it in our programs
(including Pollen documents) as well.

This book implements a ◊tag{rkt} tag function, used like so:

◊codeblock|{
#lang pollen

Check out the ◊rkt{match} function!
}|

Which produces this link to the ◊rkt{match} function.

You can read the source code in ◊repofile{doclinks.rkt}. Roughly, here is what the ◊tag{rkt} tag
function does:

◊ol{

◊li{It tries to find a ◊em{definition tag} for the given identifier, which contains information
about what module provides the documentation and what kind of thing it is. It uses a pre-defined
list of modules to search; that way we can limit the search and control the order in which they are
checked. We call ◊rkt{xref-binding->definition-tag} for each one, stopping on the first one that
succeeds (using ◊rkt{for/or}).}

◊li{If we were able to find a definition tag, we can construct a URL from that, using ◊rkt{xref-tag->path+anchor}.}

}

◊section{Quick aside: learning from the Racket documentation}

Ironically, if you wanted to learn how to do ◊em{just this} directly from the Racket documentation,
it wouldn’t be easy. You can count on the Racket docs to provide detailed technical information on
individual functions and even link you to related functions, which is great as far as it goes. But
they often neglect to provide examples of how those functions should be used together. ◊tooltip{The
Pollen documentation is a welcome exception.}

When you find yourself in this situation — that is, when you’re pretty sure you’ve found the
documentation for the functions that do what you need but you’re not gettting the bigger picture —
the best thing to do is fire up DrRacket, ◊code{require} the necessary modules, and try calling the
function(s) in question. See what results you get, and then try using the output from one as the
input for another. Looking at the outputs (in combination with a close reading of the documentation
that does exist) will put you on a navigable path. The extra work will feel strangely worth it when
you crack the problem open.

◊section{Updates}

◊i{21 Jan 2022:} Updated ◊repofile{doclinks.rkt} to point correctly to the public Racket docs.
