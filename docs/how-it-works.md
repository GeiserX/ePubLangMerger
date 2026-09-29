# How it works

1. **Extract.** The app unzips both ePub files to reach their XHTML chapter files (in `OEBPS/`).
2. **Parse.** It parses each `.xhtml` file into an XML DOM tree.
3. **Merge.** For every chapter, it inserts the paragraphs (`<p>`) and headings (`<h1>` to `<h5>`) of the second language right after the matching elements of the first language. It adds a `_2` suffix to duplicate `id` attributes.
4. **Reassemble.** It saves the changed XHTML files, copies the directory structure of the first ePub into a new folder and compresses it back into a valid `.epub` file with `Rcompression::zip`.
