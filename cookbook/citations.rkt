#lang racket

(require txexpr
         pollen/decode
         "tooltips.rkt")

(provide (all-defined-out))

;; The tag functions used in Pollen sources

;; Insert a citation
(define (cite key)
  `(cite [[ref ,(format "~a" key)]]))

;; Define a citation
(define (define-citation key . elems)
  `(cite-def [[ref ,(format "~a" key)]] ,@elems))

;; Insert the bibliography: All sources cited in this chapter
(define (insert-bibliography)
  `(bib))

(define (make-bibliography ctable)
  ; Get a list of the keys, ensure it is sorted alphabetically
  ; I had originally converted them to strings before sorting.
  ; But, turns out Racket has a function I can use with symbols directly
  (define keys-srt (sort (hash-keys ctable) string<?))

  (define list-items
    (for/list ([item (in-list keys-srt)])
      `(li ,@(hash-ref ctable item))))

  `(@ (h3 "Bibliography") (ol ,@list-items)))

;; Called from `root` in pollen.rkt -- see that function for more context
(define (citations-root-handler doc)
  ;; Local helper function: returns #true if a tag is a citation definition
  (define (is-citedef? tx)
    (and (txexpr? tx)
         (equal? (get-tag tx) 'cite-def)))

  ;; Split the citation definitions out of the main doc
  (define-values (boiled-tx citedefs) (splitf-txexpr doc is-citedef?))

  ;; Build a hash table out of the list of cite-def txexprs
  (define cite-table
    (for/hash ([c (in-list citedefs)])
      (values (attr-ref c 'ref) (get-elements c))))

  ;; Local helper function: if a txexpr is a citation, replace it with a tooltip; if it’s a
  ;; bibliography tag, replace it with the bibliography
  (define (replace-cites tx)
    (cond
      [(equal? 'bib (get-tag tx))
       (make-bibliography cite-table)]
      [(equal? 'cite (get-tag tx))
       (apply tooltip (hash-ref cite-table
                                (attr-ref tx 'ref)
                                (list (format "No def for ~a" (attr-ref tx 'ref)))))]
      [else tx]))

  ;; Run the doc through decode, applying replace-cites to every txexpr
  (decode boiled-tx #:txexpr-proc replace-cites))
