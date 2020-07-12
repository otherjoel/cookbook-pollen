#lang pollen/pre

◊(require racket/file)

◊; Since line height is used in so many places...
◊(define LINEHEIGHT 1.5)

◊(define lineheight (string-append (number->string LINEHEIGHT) "rem"))

◊(define (x-lineheight multiple) 
    (string-append (real->decimal-string (* LINEHEIGHT multiple) 2) "rem"))

◊(file->string "fonts/fonts.css")

◊(define sans-serif "'Plex Sans',-apple-system,BlinkMacSystemFont,Helvetica,Arial,sans-serif,
Apple Color Emoji,Segoe UI Emoji")

◊(define mono "'Plex Mono', 'Menlo', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', Courier,
monospace")

html {
  font-family: ◊sans-serif;
  font-size: 20px;
  color: black;
}

body {
  line-height: ◊lineheight;
  margin: 2rem 0 0 8rem;
}

aside.ribbon-tl {
  width: 300px;
  padding: 6px;
  position: fixed;
  text-align: center;
  color: #f0f0f0;
  background-color: #e43;
  top: 50px;
  right: -80px;
  transform: rotate(45deg);
}

aside.ribbon-tl a {
    text-decoration: none;
    color: #eee;
    font-family: 'PatrickSC';
}

main {
    max-width: 40rem;
}

h2, h3, h4 { 
    font-family: 'PatrickSC';
    font-feature-settings: "liga" 0; /* 'fi' ligatures inexplicably lowercase */
    font-weight: normal;
    line-height: 1em;
    margin-bottom: ◊x-lineheight[0.5];
    color: #0074D9;
}

h2 { font-size: ◊x-lineheight[1.6]; }
h3 { font-size: ◊x-lineheight[1.25]; }

h1.site-title {
    font-family: 'BDGeminis';
    font-weight: normal;
    margin-bottom: ◊x-lineheight[2.5];
    margin-left: -8px;
}

h1.site-title a {
    color: black;
    text-decoration: none;
    padding: 8px 8px 0 8px;
    transition-property: background, color;
    transition-duration: 0.1s;
}

h1.site-title a:hover {
    color: darkgoldenrod;
    background: black;
    border-radius: 4px;
}

ul.chapters {
    list-style-type: none;
}

ul.chapters li {
    margin-bottom: 0;
}

ul.chapters a {
    text-decoration: none;
    color: black;
    font-weight: bold;
    transition-property: background, color;
    transition-duration: 0.1s;
}

ul.chapters a:hover {
    background: #ddd;
    border-radius: 4px;
}

a.xref::before {
    content: '☞';
    font-size: 1.5em;
    position: relative;
    line-height: 0;
    top: 0.16em;
    left: -0.1em; /* Give the manicule a little extra room */
}

a.xref {
    text-decoration: none;
    margin-left: 0.2em; /* Give the manicule a little extra room */
    color: #0074d9;
    font-weight: bold;
}

a.file {
    color: #b60fb0;
    font-family: ◊mono;
    font-style: italic;
    letter-spacing: -1px;
    display: inline-block; /* Avoid line breaks between icon and filename */
    text-decoration: none;
}

.icon {
    fill: currentColor;
    display: inline-block;
}

.related-file .icon {
    vertical-align: text-bottom;
    padding-bottom: 1px;
}

ol {
    list-style: none;
    counter-reset: ol-counter;
}

ol li {
    counter-increment: ol-counter;
    margin-left: 2em;
    position: relative
}

ol li, ul li {
    margin-bottom: ◊x-lineheight[1];
}

ol li::before {
    display: inline-block;
    content: counter(ol-counter);
    font-family: 'PatrickSC';
    font-weight: bold;
    color: white;
    background: #666;
    width: 1.5em;
    height: 1.5em;
    position: absolute;
    left: -2.5em;
    line-height: 1.5em;
    border-radius: 0.1em;
    text-align: center;
    margin-right: 2em;
}

pre.code {
    font-family: ◊mono;
    font-size: 0.8rem;
    color: rebeccapurple;
    line-height: 1.3em;
    border-top: solid 1px lightgray;
    border-bottom: solid 1px lightgray;
    padding: 8px 0 8px 8px;
    border-radius: 8px;
}

pre.code mark {
    color: rebeccapurple;
    background: #fff0cb;
}

b.repl {
    color: black;
    font-weight: bold;
}

span.repl-code {
    color: navy;
}

code {
    font-family: ◊mono;
    color: #966b00;
    font-style: italic;
    letter-spacing: -1px;
}

code .pollen-mode {
    font-style: normal;
}

/* Match X-height when using code in headings */
h2 code, h3 code, h4 code {
    font-size: 0.85em;
}

samp {
    font-family: ◊sans-serif;
    font-style: italic;
    color: navy;
    background: #f6f6f6;
    border: dashed 1px darkgray;
    padding: 3px;
    border-radius: 3px;
}


◊(dynamic-require "tooltips.css.pp" 'doc)

◊(dynamic-require "repolinks.css.pp" 'doc)
