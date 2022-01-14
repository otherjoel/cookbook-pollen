#lang pollen

◊(define-meta published "2020-06-14")

◊title{How to Design Pollen Markup}

A layman’s attempt at applying the
◊link["https://htdp.org/2020-5-6/Book/part_preface.html#%28part._sec~3asystematic-design%29"]{◊i{How
to Design Programs} design recipe} to programming in Pollen:

◊ol{
◊li{Think about and decide what kinds of things will be in your book, given your subject matter.
Decide how you would like to mark these things up in your Pollen source.}
◊li{For each thing, find or make a working example of these things in plain HTML and CSS.}
◊li{In DrRacket, ◊code{define} a static
◊link["https://docs.racket-lang.org/pollen/second-tutorial.html#%28part._.X-expressions%29"]{X-expression}
that is equivalent to the HTML markup from your working example.}
◊li{Write a function (or set of functions) that produce this X-expression.}
◊li{Add inputs to this function and refine it so that it can do all the things you envisioned in
Step 2.}
}

