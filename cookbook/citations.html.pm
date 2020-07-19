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

◊li{Save state somewhere and defer processing to a later tag function that can see more of the
doc (usually ◊code{root})}

}

Both of these approaches are valid and idiomatic. The first is simpler, and suited to a project
where the same information is used across multiple Pollen sources. But sometimes it isn’t an option;
sometimes the information you need can only be found elsewhere in the same document. That’s when
the second approach is needed.

◊section{Our implementation}

I’m going to explain how this book puts all of the above into practice. Remember, to see the code
itself, check out the contents of ◊repofile{citations.rkt}.

◊strong{Defining a citation:} The ◊tag{define-citation} tag emits a ◊code{cite-def} X-expression
with a ◊code{ref} attribute.

◊strong{Referencing a citation:} The ◊tag{cite} tag likewise emits a ◊code{cite} X-expression with a
◊code{ref} attribute.

◊strong{Inserting a bibliography:} The ◊tag{insert-bibliography} tag inserts ◊code{'(bib)}. That’s
it, ◊link["https://knowyourmeme.com/memes/thats-it-thats-the-tweet"]{that’s the tweet}.

These tag functions don’t actually do much; they just leave behind little “marker” X-expressions in
the doc that don’t actually give us the functionality we want — not by themselves.

Recall we’re taking the second approach above: saving the information we’ll need, and deferring
further processing until the ◊code{root} function. Where do we save the information? We’re saving it
right in the doc.

Here’s what the doc from our example markup looks like ◊em{after} these tag functions have been
called, but ◊em{before} the ◊code{root} function is called:

◊codeblock{
'(root
  "Paragraphs are important. " (cite [[ref "1"]])
  (cite-def [[ref "1"]] "Chicago Manual of Style, 15th edition")
  (bib))
}

When the ◊code{root} function is called, it has visibility into the entire doc. If you look at this
function in ◊repofile{pollen.rkt} you’ll see it calls ◊code{citations-root-handler} from
◊repofile{citations.rkt}. This function does three things:

◊ol{

◊li{Splits out the ◊code{cite-def} X-expressions from the doc using ◊code{splitf-txexpr} and
converts them into a hash table}

◊li{Using ◊code{decode}, replaces all the ◊code{cite} X-expressions with ◊xref["tooltips"]{tooltips}
containing the matching entry from the hash table; and replaces any occurrence of ◊code{'(bib)} with
a list of ◊em{all} the entries from that hash table.}

}

◊section{What else could we do?}

◊ul{

◊li{Omit the ◊tag{insert-bibliography} tag and just insert a bibliography at the end automatically
if there are any uses of ◊tag{define-citation}.}

◊li{There is a good reason for the ◊tag{cite} tag to leave behind a marker in the document: the
location in the document where the citation occurred is part of the info we need to keep track of.
But the same is not true of ◊tag{define-citation}: the location where the citation is defined is not
useful or needed. So rather than leaving a marker, ◊tag{define-citation} could simply return an
empty string and add its contents to a hash table. Then you wouldn’t need step 1 above; by the time
◊code{root} is called, the hash table would be all ready for you and there’d be no ◊code{cite-def}
X-expressions lying around to clean out of the doc. }

}
