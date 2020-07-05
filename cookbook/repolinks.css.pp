#lang pollen/pre

nav { 
    display: grid;
    grid-template-columns: 10rem 10rem;
    margin-bottom: 1.3rem;
    margin-top: -2.6rem;
}

nav a {
    text-decoration: none;
    width: 100%;
    font-family: PatrickSC;
    font-size: 1rem;
    text-align: center;
    color: #666;
}

nav a:hover {
    background: #666;
    color: white;
}

.file-list {
    display: inline-block;
    font-size: 0.7rem;
    border-top: solid #ccc 1px;
    border-left: solid #ccc 1px;
    border-right: solid #ccc 1px;
}

.related-file {
    display: grid;
    grid-template-columns: 12em auto;
    grid-column-gap: 1rem;
    border-bottom: solid #ccc 1px;
    padding: 0 0.5rem;
}

.related-file a.file {
    text-decoration: none;
}

