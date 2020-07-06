#lang pollen
◊define-meta[files (("index.ptree" "The pagetree: defines chapter order and structure"))]

◊(define-meta template "template-index.html.p")

◊; We need a “dummy” second element here so that the list of linked files get placed after it
◊span{}

◊section{Front Matter}

◊section-listing['frontmatter]

◊section{General Pollen-Fu}

◊section-listing['general]

◊section{Tags}

◊section-listing['tags]
