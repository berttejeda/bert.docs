---
title: Title Here
subtitle: Some Subtitle
author:
- name: Author Name
sections:
- name: Section 1
  id: section1
- name: Section 2
  id: section2
- name: Section 3
  id: section3
- name: Section 4
  id: section4
date: 08.13.2018
<!-- header-includes: 
- <script src="assets/jquery/hello.js"></script> -->
---
<div id="start">

# Start Page

This is your starting page.

Here, you can introduce your readers to the purpose of the document, as well as provide any useful information pertinent to its goals.

# HTML Structures

Below are some HTML structures you will no doubt find useful.

## Paragraph

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 

Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Italics, bold, superscript, subscript, strikeout

*Italics* and **bold** are indicated with asterisks. 

To ~~strikeout~~ text use double tildas. 

Superscripts use carats, like so: 2^nd^. 

Subscripts use single tildas, like so: H~2~O. 

Spaces inside subscripts and superscripts must be escaped, 
e.g., H~this\ is\ a\ long\ subscript~.

Inline code goes between backticks: `echo 'hello'`.

## Code blocks

```bash

$ # Lorem ipsum dolor
$ echo Lorem ipsum dolor
$ # consectetur adipiscing elit
$ rm -f consectetur

```

## Links and images

Weblink: <http://example.com>

Weblink with Text: [Example](http://example.com)

Email link: <foo@bar.com>

Inline Link: [inline link](http://example.com "Title")

[reference link][someid]

[someid]: http://example.com "Title"

[implicit reference link][]

[implicit reference link]: http://example.com

[someotherid]: _template/assets/images/icon.png
![inline image](_template/assets/images/icon.png)
![reference image][someotherid]

This is a link to a footer [^1]

[^1]: This is some footer with two links
    <http://www.google.com> and
    <http://www.wikipedia.com>.

## Footnotes

    Inline notes are like this.^[Note that inline notes cannot contain multiple paragraphs.] Reference notes are like this.[^id]

    [^id]:  Reference notes can contain multiple paragraphs.

        Subsequent paragraphs must be indented.

## Headers

Header 1
========

Header 2
--------

# Header 1 #

## Header 2 ##

Closing \#s are optional. Blank line required before and after each
header.

## Lists

### Ordered lists

1. example
2. example

A) example
B) example

### Unordered lists

Items may be marked by '\*', '+', or '-'.

+   example
-   example
*   example

Lists may be nested in the usual way:

 +   example
     +   example
 +   example

### Definition lists

Term 1
  ~ Definition 1

Term 2
  ~ Definition 2a
  ~ Definition 2b

Term 1
:   Definition 1

Term 2
:   Definition 2

    Second paragraph of definition 2
    
    Third  paragraph of definition 2

## Blockquotes

 >   blockquote

 >>  nested blockquote

Blank lines required before and after blockquotes.

## Tables

  Right     Left     Center     Default
-------     ------ ----------   -------
     12     12        12            12
    123     123       123          123
      1     1          1             1

Table:  Demonstration of simple table syntax (with css applied, see build.sh)

(For more complex tables, see the pandoc documentation.)

## Code Blocks

Begin with three or more tildes; end with at least as many tildes:

~~~~~~~
{code here}
~~~~~~~

Optionally, you can specify the language of the code block:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.haskell .numberLines}
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs) 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

```python
tmpl_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        'templates')
app = Flask(__name__, template_folder=tmpl_dir)
```

```html
<head></head>
<body>
This is HTML
</body>
```

```css
body {
    font-family: "PT Sans";
}
```

```bash
$ echo this is bash
$ # execute the following line only if dist/ exists and there's stuff inside
$ rm dist/*
$ # the following command builds the source distribution
$ python setup.py sdist
$ # the following command uploads the package to PyPI!!!!!!!!
$ twine upload dist/*
$ # you will be prompted for username & password to PyPI
$ # remove stuff under dist/* to keep it clean for updates.
$ rm dist/*
```      

## Horizontal Rules

3 or more dashes or asterisks on a line (space between okay)

---

* * *

- - - -

</div>