#lang pollen

◊define-meta[files (("repolinks.rkt" "Tag functions for GitHub links")
                    ("repolinks.css.pp" "CSS styles for GitHub links"))]


◊title{GitHub links}

The source code for this book, and everything it demonstrates, is stored on GitHub. Linking back to
that source code is an easy way to help the reader jump back and forth between the finished product
and the code that produced it.

◊section{Simple links}

The first addition is a ◊code{◊"◊"repolink} tag function. We pass it a simple filename like
◊code{LICENSE.md}. It prefixes this filename with the URL of the GitHub repo and returns an
X-expression for a link to that file in the repo, like this: ◊repofile{LICENSE.md}.

As you can see, the link contains an inline SVG icon and some CSS styling info.

◊section{Adding a list of files in each chapter}

In addition to sprinkling these links within the text of a chapter, each chapter should present a
list of related files right at the top. At a minimum, this would always include a link to the Pollen
source for the chapter itself.

A chapter can add files to this list by adding a ◊code{files} meta with ◊code{define-meta}.

To generate the X-expression for the list of these files, ◊repofile{repolinks.rkt} defines a function,
◊code{file-link-list}, which grabs the list of files to use from the current metas.

We don’t have to call this function from our chapters though. We’ll have it inserted into every file
automatically. We define a function ◊code{repolink-root-handler} that takes the complete doc and
returns the same doc with the file list inserted ◊em{after the second element} in the doc.

◊strong{Why after the second element?} Because as the author of the book, I’ve decided that I’ll
start each chapter with a ◊code{title} tag, so the doc will always look like this:

◊codeblock{
'(doc-tag (title "Title") ...)
}

The first element is always the doc’s tag, the second element is the title. I don’t need to do some
fancy parsing to find the title tag; I can be a little lazy and assume it’s the second thing in the
doc.

This ability to tailor how exactly your markup works is one of Pollen’s strengths. You can decide
whether to put a lot of effort into making your markup as smart and as flexible as possible. Or you
can take shortcuts based on reasonable assumptions. Your markup can be as smart or as lazy as you
like. You’re not designing it for thousands of other people: you’re designing it for this one
specific project.

◊strong{Did using this “second element” method come back to bite you though?} Well, it had an
unexpected consequence on the book’s home page. There is no ◊code{title} tag on that page (since the
header suffices for a title). So I added an empty ◊code{◊"◊"span} tag at the top. This is invisible
to the reader in the published HTML, but it is enough to count as the second element on the page, so
that the file list gets placed properly.

I could have done more work to treat the home page differently from other pages; but this is good
enough for now.
