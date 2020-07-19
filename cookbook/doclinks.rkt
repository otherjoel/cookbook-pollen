#lang racket/base

(require setup/xref
         scribble/xref
         racket/list
         racket/syntax)

(provide modules-to-search
         rkt)

;; These are the modules that will be checked in order to try and find documentation links.
;; The packages containing these modules MUST be installed in “installation scope” in order
;; for this to work (see https://groups.google.com/g/racket-users/c/zIeAaJULzzI)
(define modules-to-search (make-parameter '(racket txexpr pollen scribble/xref)))

(define xrefs (load-collections-xref))

(define name->definition-tag
  (let ([tag-cache (make-hash)])
    (lambda (name)
      (define identifier (format-symbol "~a" name))
      (hash-ref! tag-cache
                 identifier
                 (lambda _ (for/or ([module-path (in-list (modules-to-search))])
                             (xref-binding->definition-tag xrefs (list module-path identifier) #f)))))))

(define (racket-docs-link name)
  (define definition-tag (name->definition-tag name))
  (cond
    [definition-tag
      (define-values (path url-tag)
        (xref-tag->path+anchor xrefs
                               definition-tag
                               #:external-root-url "http://docs.racket-lang.org/"))
      `(a [[href ,(format "~a#~a" path url-tag)]
           [class "rkt-docs"]]
          (code ,name))]
    [else `(code ,name)]))

;; Faster to type:
(define rkt racket-docs-link)
