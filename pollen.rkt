#lang racket/base

(require racket/list
         pollen/core
         pollen/decode
         pollen/tag
         pollen/pagetree
         txexpr
         pollen/template)

(provide ->html (all-defined-out))

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


  ;; Produce a final X-expression for the doc
  (decode boiled-tx 
          #:txexpr-proc replace-cites
          #:txexpr-elements-proc hardwrapped-grafs
          #:exclude-tags '(pre)))

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

(define (xref slug . elements)
  `(a [[class "xref"] [href ,(format "~a.html" slug)]] ,@elements))

(define (cite key)
  `(cite [[ref ,(format "~a" key)]]))

(define (define-citation key . elems)
  `(cite-def [[ref ,(format "~a" key)]] ,@elems))

(define (insert-bibliography)
  `(bib))

(define (repofile filename)
  (define repo-url "https://github.com/otherjoel/cookbook-pollen")
  `(a [[class "file"] 
       [title ,(format "View ~a on the GitHub repo" filename)]
       [href ,(format "~a/blob/master/~a" repo-url filename)]]
      (svg [[aria-label "file"] 
            [class "icon icon-file"]
            [viewBox "0 0 16 16"]
            [version "1.1"]
            [width "16"]
            [height "16"]
            [role "img"]]
           (path [[fill-rule "evenodd"]
                  [d "M3.75 1.5a.25.25 0 00-.25.25v11.5c0 .138.112.25.25.25h8.5a.25.25 0 
                     00.25-.25V6H9.75A1.75 1.75 0 018 4.25V1.5H3.75zm5.75.56v2.19c0 
                     .138.112.25.25.25h2.19L9.5 2.06zM2 1.75C2 .784 2.784 0 3.75 0h5.086c.464 
                     0 .909.184 1.237.513l3.414 3.414c.329.328.513.773.513 1.237v8.086A1.75 1.75 
                     0 0112.25 15h-8.5A1.75 1.75 0 012 13.25V1.75z"]]))
      ,filename))
;;
;; Page tree stuff!! ~~~~~~~~~~~~~~~~~~~
;;
(define (section-listing sym)
  (define (maybe-title p)
    (if (file-exists? (symbol->string p)) (car (select-from-doc 'h2 p)) `(i ,(symbol->string p))))
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
