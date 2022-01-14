#lang racket/base

(require (prefix-in ptree: "index.ptree")
         pollen/core
         racket/file
         racket/list
         racket/string
         splitflap
         txexpr)

;; Need a unique ID for the feed and its items
(define book-id
  (mint-tag-uri "joeldueck.com" "2020" "pollen-cookbook"))

(define book-url "https://thelocalyarn.com/excursus/pollen-cookbook/")

;; Gather all docs
(define (get-chapters)
  (flatten
   (for/list ([node (in-list ptree:doc)]
              #:when (list? node))
     (cdr node))))

;; Gets a doc and removes the list of related files from the top
(define (feed-doc page)
  (define-values (doc files)
    (splitf-txexpr
     (get-doc page)
     (λ (tx) (and (list? tx)
                  (eq? (car tx) 'div)
                  (equal? (attr-ref tx 'class #f) "file-list")))))
  doc)

;; Convert each Pollen source to a feed item
(define (chapter->feed-item page)
  (define doc (feed-doc page))
  (define metas (get-metas page))
  (define chap-id (car (string-split (symbol->string page) ".")))
  (define published (hash-ref metas 'published))
  (feed-item (append-specific book-id chap-id)
             (format "~a~a" book-url page)
             (car (select-from-doc 'h2 doc))
             (person "Joel Dueck" "joel@jdueck.net" "https://joeldueck.com")
             (infer-moment published)
             (infer-moment (hash-ref metas 'updated published))
             doc))

;; Generate the feed
(define (make-feed!)
  (define items (map chapter->feed-item (get-chapters)))

  (display-to-file
   (express-xml (feed book-id
                      book-url
                      "The Pollen Cookbook"
                      items)
                'atom
                (format "~afeed.atom" book-url))
   "feed.atom"
   #:exists 'truncate))