#lang pollen/pre

◊; Since line height is used in so many places...
◊(define LINEHEIGHT 1.4)

◊(define lineheight (string-append (number->string LINEHEIGHT) "rem"))

◊(define (x-lineheight multiple) 
    (string-append (real->decimal-string (* LINEHEIGHT multiple) 2) "rem"))

@font-face {
    font-family: 'BDGeminis';
    src: url('fonts/bd_geminis.woff') format('woff');
    font-weight: normal;
    font-style: normal;
}

@font-face {
    font-family: 'PatrickSC';
    src: url('fonts/patrickhandsc.woff') format('woff');
    font-weight: normal;
    font-style: normal;
}

@font-face {
    font-family: 'CourierPrime';
    src: url('fonts/courier_prime.woff') format('woff');
    font-weight: normal;
    font-style: normal;
}

@font-face {
    font-family: 'CourierPrime';
    src: url('fonts/courier_prime_bold.woff') format('woff');
    font-weight: bold;
    font-style: normal;
}

@font-face {
    font-family: 'CourierPrime';
    src: url('fonts/courier_prime_italic.woff') format('woff');
    font-weight: normal;
    font-style: italic;
}

html {
  font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Helvetica,Arial,sans-serif,
               Apple Color Emoji,Segoe UI Emoji;
  font-size: 22px;
  color: black;
}

body {
  line-height: ◊lineheight;
  margin: 2rem 0 0 8rem;
  max-width: 30rem;
}

h1, h2, h3, h4 { 
    font-family: 'PatrickSC';
    font-weight: normal;
    line-height: 1em;
    margin-bottom: ◊x-lineheight[0.5];
}

h1.site-title {
    font-family: 'BDGeminis';
    font-weight: normal;
    margin-bottom: ◊x-lineheight[2];
}

pre.code {
    font-family: 'CourierPrime';
    background: #eee;
}

/* 
 * BR-style tooltips *****************************************/

.tooltip {
    display: inline;
    position: relative;
    background: white;
    opacity: 0.5;
    transition-property: opacity;
    transition-duration: 0.20s;
    color: black;
    width: 1rem;
    border: solid 1px grey;
    box-sizing: content-box;
    border-radius: 0.2em;
    cursor: pointer;
}

.tooltip-inner {
    visibility: hidden;
    display: block;
    position: absolute;
    right: -1px;
    bottom: 1rem;
    width: 12rem;
    background: #999;
    color: white;
    padding: 1em;
    font-size: 85%;
    border-radius: 0.5em 0.5em 0 0.5em;
    transform-origin: right bottom;
    transform: scale(0.4);
    opacity: 0;
    transition-property: all;
    transition-duration: .2s;
}

.tooltip_visible .tooltip-inner {
    visibility: visible;
    transform-origin: right bottom;
    transform: scale(1);
    opacity: 1;
    cursor: pointer;
}

.tooltip:hover, .tooltip.tooltip_visible {
    background: #999;
    color: white;
    opacity: 1;
    transition-property: opacity;
    transition-duration: 0.20s;
}
