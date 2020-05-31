#lang pollen/pre

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

