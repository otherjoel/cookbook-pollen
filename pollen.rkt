#lang racket/base

(require racket/list
         pollen/template)

; <span class="tooltip" onclick="this.classList.toggle('tooltip_visible')">
; &nbsp;+&nbsp;
; <span class="tooltip-inner"> For demonstration purposes, we’re trapping these errors using wiith-handlers. See <a class="explainer" href="/explainer/errors-and-exceptions.html">errors and exceptions</a>.
; </span></span>

(define example
  '(span [[class "tooltip"]
          [onclick "this.classList.toggle('tooltip_visible')"]]
         " + "
         (span [[class "tooltip-inner"]]
               "For demonstration purposes, we’re trapping these errors using wiith-handlers")
         )        
  )

(provide tooltip)

(define (tooltip . elements)
  `(span [[class "tooltip"]
          [onclick "this.classList.toggle('tooltip_visible')"]]
         " + "
         (span [[class "tooltip-inner"]]
               ,(first elements) )
         )
)