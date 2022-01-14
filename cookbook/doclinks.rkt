#lang racket/base

(require pkg/path
         racket/list
         racket/syntax
         scribble/xref
         setup/xref)

(provide modules-to-search
         rkt)

;; These are the modules that will be checked in order to try and find documentation links.
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

;; For discussion of why exception handling is needed here,
;; see https://groups.google.com/g/racket-users/c/zIeAaJULzzI
(define (racket-docs-link name)
  (define def-tag (name->definition-tag name))
  (define href
    (and def-tag
         (with-handlers
           ([exn:fail:contract? ; exceptions happen when pkg installed in user scope!
             (λ _
               (define-values (p anchor) (xref-tag->path+anchor xrefs def-tag))
               (define-values (_ subpath) (path->pkg+subpath p))
               ;; Hack together a URL, should work in most cases
               (format "~a~a#~a"
                       "https://docs.racket-lang.org/"
                       ;; drop `doc/` from the front of the subpath:
                       (path->string (apply build-path (drop (explode-path subpath) 1)))
                       anchor))])
           (define-values (path anchor)
             (xref-tag->path+anchor xrefs
                                    def-tag
                                    #:external-root-url "http://docs.racket-lang.org/"))
           (format "~a#~a" path anchor))))
  (cond
    [href
     `(a [[href ,href]
           [class "rkt-docs"]]
          (code ,name))]
    [else `(code ,name)]))

;; Faster to type:
(define rkt racket-docs-link)
