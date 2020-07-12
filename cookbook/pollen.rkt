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
(require "repolinks.rkt"
         "tooltips.rkt"
         "citations.rkt")

(provide ->html (all-defined-out))

;; Provide the functions related to specific chapters in the book:
(provide (all-from-out "repolinks.rkt"
                       "tooltips.rkt"
                       "citations.rkt"))

(define (chapter-pagetree)
  (cons 'root (flatten (map rest (filter list? (get-pagetree "index.ptree"))))))

(define (root . elems)
  ;; Run doc through any special handlers defined by chapter-specific functionality. Doing it this
  ;; way is a little inefficient; we could combine a lot of these into a single call to `decode`.
  ;; But it makes it easier for you to understand each piece of functionality separately from the
  ;; others.
  (let* ([doc `(main ,@elems)]
         [doc (citations-root-handler doc)]
         [doc (repolink-root-handler doc)])
    ;; Produce a final X-expression for the doc
    (decode doc
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

(define (tag . elements)
  `(code (span [[class "pollen-mode"]] "◊") ,@elements))

(define (>> . elements)
  `(@ (b [[class "repl"]] "> ") (span [[class "repl-code"]] ,@elements)))

(define (link url . elements)
  `(a [[href ,url]] ,@elements))

(define (Pollen [str "Pollen"]) 
  (link "https://pollenpub.com" str))

(define (xref slug . elements)
  `(a [[class "xref"] [href ,(format "~a.html" slug)]] ,@elements))

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
