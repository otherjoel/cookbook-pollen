<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>◊(or (select 'h2 doc) "Pollen Cookbook")</title>
    <link rel="stylesheet" href="style.css">
    <link rel="alternate" type="application/atom+xml" title="Atom feed" href="https://thelocalyarn.com/excursus/pollen-cookbook/feed.atom" />
  </head>
  <body>

    <aside class="ribbon-tl"><a href="https://github.com/otherjoel/cookbook-pollen">Work in progress!</a></aside>

  <h1 class="site-title"><a href="/index.html">The Pollen Cookbook</a></h1>
  <nav>
    ◊when/splice[(previous here (chapter-pagetree))]{
        <a href="◊(previous here (chapter-pagetree))">&larr; Previous Chapter</a>
    }

    ◊when/splice[(next here (chapter-pagetree))]{
        <a href="◊(next here (chapter-pagetree))">Next Chapter &rarr;</a>
    }
  </nav>

  ◊(->html doc)
  </body>
</html>
