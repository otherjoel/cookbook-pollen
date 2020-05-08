#lang racket/base

(require racket/list
         pollen/template)

(provide ->html (all-defined-out))

;;
;; Basic tag functions!  ~~~~~~~~~~~~~~~
;;
(define (codeblock . elements)
  `(pre [[class "code"]] ,@elements))

(define (link url . elements)
  `(a [[href ,url]] ,@elements))

;;
;; Citations! Bibliography!  ~~~~~~~~~~~~~~~
;;

(define citations-table (make-hash))

(define (define-citation key . elems)
  (hash-set! citations-table key elems))

(define (cite key)
  (apply tooltip (hash-ref citations-table
                           key
                           (list (format "No def for ~a" key)))))

(define (insert-bibliography)
  ; Get a list of the keys, ensure it is sorted alphabetically
  ; I had originally converted them to strings before sorting.
  ; But, turns out Racket has a function I can use with symbols directly 
  (define keys-srt (sort (hash-keys citations-table) symbol<?))
  
  (define list-items
    (for/list ([item (in-list keys-srt)])
      `(li ,@(hash-ref citations-table item))))
  
  `(@ (h3 "Bibliography") (ol ,@list-items)))


;;
;; Tool tips!  ~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
(define (tooltip . elements)
  `(span [[class "tooltip"]
          [onclick "this.classList.toggle('tooltip_visible')"]]
         " + "
         (span [[class "tooltip-inner"]]
               ,@elements)
         ))