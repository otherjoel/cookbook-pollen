#lang racket

(provide (all-defined-out))

(define (tooltip . elements)
  `(span [[class "tooltip"]
          [onclick "this.classList.toggle('tooltip_visible')"]]
         nbsp "+" nbsp
         (span [[class "tooltip-inner"]]
               ,@elements)
         ))
