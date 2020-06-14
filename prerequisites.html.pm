#lang pollen

◊title{Pre-requirisites}

This book should not be your introduction to Pollen and Racket. You probably will not get anything
out of this book unless you first read the ◊Pollen{Pollen documentation} and work through the
tutorials.

The
◊link["https://docs.racket-lang.org/pollen/second-tutorial.html?q=pollen#%28part._.X-expressions%29"]{section
on X-expressions} is of particular importance. You should also read
◊link["https://docs.racket-lang.org/txexpr/index.html"]{the documentation for the ◊code{txexpr}
package}.◊tooltip{This is a standalone package in Racket. It is separate from Pollen (and therefore,
so is its documentation), but because it is one of Pollen’s dependencies, it gets installed
automatically when you install Pollen.} All Pollen documents are compiled into tagged X-expressions,
so learning how to recognize, generate and manipulate valid tagged X-expressions is a critical
skill. In particular, many of the error messages you get will ultimately trace back to an invalid
tagged X-expression being generated somewhere within your document.

This book also assumes you understand HTML and CSS.
