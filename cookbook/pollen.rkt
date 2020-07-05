#lang racket/base

(require pollen/core
         pollen/decode
         pollen/file
         pollen/pagetree
         pollen/tag
         pollen/template
         racket/list
         racket/match
         txexpr)

;; Import functions related to specific chapters in the book
(require "repolinks.rkt")

(provide ->html (all-defined-out))

;; Provide the functions related to specific chapters in the book:
(provide (all-from-out "repolinks.rkt"))

(define (chapter-pagetree)
  (cons 'root (flatten (map rest (filter list? (get-pagetree "index.ptree"))))))

(define (make-bibliography ctable)
  ; Get a list of the keys, ensure it is sorted alphabetically
  ; I had originally converted them to strings before sorting.
  ; But, turns out Racket has a function I can use with symbols directly 
  (define keys-srt (sort (hash-keys ctable) string<?))

  (define list-items
    (for/list ([item (in-list keys-srt)])
      `(li ,@(hash-ref ctable item))))
  
  `(@ (h3 "Bibliography") (ol ,@list-items)))

(define (root . elems)
  ;; Grab alll the definitions out of the doc
  (define (is-citedef? tx)
    (and (txexpr? tx)
         (equal? (get-tag tx) 'cite-def)))
  (define-values (boiled-tx citedefs)
    (splitf-txexpr `(main ,@elems) is-citedef?))

  (define cite-table
    (for/hash ([c (in-list citedefs)])
      (values (attr-ref c 'ref) (get-elements c))))
  
  ;; Replace all citations with reference
  (define (replace-cites tx)
    (cond
      [(equal? 'bib (get-tag tx))
       (make-bibliography cite-table)]
      [(equal? 'cite (get-tag tx))
       (apply tooltip (hash-ref cite-table
                                (attr-ref tx 'ref)
                                (list (format "No def for ~a" (attr-ref tx 'ref)))))]
      [else tx]))

  ;; Run doc through any special handlers defined by chapter-specific functionality Doing it this
  ;; way is a little inefficient; we could combine a lot of these into a single call to `decode`.
  ;; But it makes it easier for you to understand each piece of functionality separately from the
  ;; others.
  (let* ([doc `(main ,@elems)]
         [doc (repolink-root-handler doc)])
    ;; Produce a final X-expression for the doc
    (decode doc
            #:txexpr-proc replace-cites
            #:txexpr-elements-proc hardwrapped-grafs
            #:exclude-tags '(pre))))

(define (hardwrapped-grafs xs)
  (define (newline-to-space xs)
    (decode-linebreaks xs " "))
  (decode-paragraphs xs #:linebreak-proc newline-to-space))

;;
;; Basic tag functions!  ~~~~~~~~~~~~~~~
;;

(define title (default-tag-function 'h2))
(define section (default-tag-function 'h3))

(define (codeblock . elements)
  `(pre [[class "code"]] ,@elements))

(define (>> . elements)
  `(@ (b [[class "repl"]] "> ") (span [[class "repl-code"]] ,@elements)))

(define (link url . elements)
  `(a [[href ,url]] ,@elements))

(define (Pollen [str "Pollen"]) 
  (link "https://pollenpub.com" str))

(define (xref slug . elements)
  `(a [[class "xref"] [href ,(format "~a.html" slug)]] ,@elements))

(define (cite key)
  `(cite [[ref ,(format "~a" key)]]))

(define (define-citation key . elems)
  `(cite-def [[ref ,(format "~a" key)]] ,@elems))

(define (insert-bibliography)
  `(bib))

;;
;; Page tree stuff!! ~~~~~~~~~~~~~~~~~~~
;;
(define (section-listing sym)
  (define (maybe-title p)
    (match (get-source p)
      [(? path? src) (car (select-from-doc 'h2 src))]
      [_ `(i ,(symbol->string p))]))
  
  (define list-items
    (map (λ (p) `(li (a [[href ,(format "/~a" p)]] ,(maybe-title p))))
         (children sym "index.ptree")))
  `(ul [[class "chapters"]] ,@list-items))
  
;;
;; Tool tips!  ~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
(define (tooltip . elements)
  `(span [[class "tooltip"]
          [onclick "this.classList.toggle('tooltip_visible')"]]
         nbsp "+" nbsp
         (span [[class "tooltip-inner"]]
               ,@elements)
         ))
