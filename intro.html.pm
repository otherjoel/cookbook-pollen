#lang pollen

◊title{Pre-ramble}

◊Pollen[] is a language and programming environment for publishing books, or anything. It is ideal
for those who want to design their own markup and to have maximum control over the finished results
produced by that markup.

“Maximum control” means that Pollen gives you building blocks. Out of the box, you can write in
Markdown or HTML. But if you want to do anything interesting — footnotes, bibliographies, automatic
links, backlinks, diagrams — you need to program those interesting things yourself. 

Often people on the Pollen Users group will ask how to reproduce these features. Sometimes they ask
the question in a form like “What is the trick or code for making footnotes in Pollen?” — as though
Pollen had a hidden function for producing footnotes that just wasn’t documented. But Pollen doesn’t
provide a facility for creating footnotes; you provide it. The virtue of having to do this is that
your footnotes will work exactly the way you want them to. You don’t have to beg the creators of
your tools for a feature you want, and they don’t have to maintain an endless list of design
customizations.

But examples do help. One of the first things I remember asking about was how I should make an RSS
feed for a Pollen project. Pollen doesn’t come with a way to generate RSS feeds. But in response to
my question Matthew Butterick wrote a short module demonstrating how to do it. Reading and poking
around in that code filled in a lot of gaps for me.

This book, like ◊link["https://archive.org/details/Basic_Cookbook_1978_Tab_Books/mode/2up"]{its 1978
namesake}, is a collection of examples and techniques. It will show you possible ways of putting the
ingredients together to implement some of those “interesting” features in your own Pollen projects.
