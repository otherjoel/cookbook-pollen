#lang racket

;; Tag functions for linking back to this book's GitHub repo

(require txexpr pollen/core)

(provide (all-defined-out))

;; Insert a link to a file at this book's GitHub repo
;; Uses an inline SVG file for the file icon
(define (repofile filename)
  (define repo-url "https://github.com/otherjoel/cookbook-pollen")
  `(a [[class "file"]
       [title ,(format "View ~a on the GitHub repo" filename)]
       [href ,(format "~a/blob/master/cookbook/~a" repo-url filename)]]
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

;; Using the "files" meta (which should be a list of 2-element lists), create a list of links back
;; to the GitHub repo. The list will always include a GitHub link for the current file. This does no
;; checking about whether the files actually exist.
(define (file-link-list)
  (define this-file
    (path->string (last (explode-path (string->path (hash-ref (current-metas) 'here-path))))))

  (define files (hash-ref (current-metas) 'files '() ))
  (define flist (cons (list this-file "Pollen source for the text of this chapter")
                      files))
  (define (file-row row-data)
    `(div [[class "related-file"]]
          ,(repofile (first row-data))
          (span ,(second row-data))))
  `(div [[class "file-list"]]
        ,@(map file-row flist)))


;; A function to be called from root Insert the file link list after the second element in the doc
;; (which we assume will be the title)
(define (repolink-root-handler doc)
  (match doc
    [(txexpr tag attrs (cons title rest-doc))
     `(,tag ,attrs ,title ,(file-link-list) ,@rest-doc)]))
