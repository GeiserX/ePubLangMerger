# Troubleshooting

## Chapters are missing or paired with the wrong chapter

- **Cause:** the tool pairs the XHTML chapter files inside `OEBPS/` by position, not by name: the first file of one ePub with the first file of the other, and so on. Both ePubs need the same number of chapter files in the same order.
- **Fix:** use two editions built the same way (same publisher and same conversion tool), so the chapter files line up.

## The end of a chapter is in one language only

- **Cause:** paragraph and heading counts differ between the two languages. For each tag, the tool pairs only as many elements as the shorter chapter has. Unpaired first-language elements stay in the output; unpaired second-language elements are dropped.
- **Fix:** none in the tool; the merge is positional. Check that both editions split paragraphs the same way.

## Quotes, lists or boxes are not merged

- **Cause:** only `<p>` and `<h1>` through `<h5>` elements are merged, wherever they sit: a `<p>` inside a `<blockquote>` or a `<div>` is merged, but text written straight into a list item (`<li>`), a table cell or a `<div>` without a `<p>` is not.
- **Fix:** none today; that text appears in the first language only.

## The merged book is the first ePub, unchanged

- **Cause:** the tool reads only the chapter files inside `OEBPS/` whose names end in `.xhtml`. When the first ePub keeps its chapters anywhere else (`OPS/`, `EPUB/text/`, the top of the archive) or names them `.html`, there is nothing to merge, and the tool zips the first ePub as it was. When the second ePub is the one laid out that way, the merge stops with `Error: subscript out of bounds`.
- **Fix:** none in the tool today. An ePub is a ZIP file: list it (`unzip -l book.epub`) before merging and check that both keep their chapters as `OEBPS/*.xhtml`.

## A new file gives the same merged book as before

- **Cause:** within one browser session the tool keeps each merged book under its output name, and hands it back for any later pair that gives the same output name, without a new merge. The output name comes from the first file's name and only the language code of the second (see [Usage](usage.md)), so after merging `MyBook_EN.epub` with `MyBook_ES.epub`, pairing `MyBook_EN.epub` with a different book named `Other_ES.epub` gives the same `MyBook_EN_ES.epub` and the old result.
- **Fix:** reload the page to start a new session. Renaming a file helps only when it changes the output name.

## The reader shows the title or language of the first ePub

- **Cause:** the tool does not modify the ePub's OPF metadata (title, language, etc.).
- **Fix:** edit the metadata afterwards with an ePub editor such as Calibre.

## Reporting a bug

Open an [issue](https://github.com/GeiserX/ePubLangMerger/issues) with the two input filenames, how you ran the tool (Docker, R or `script.R`), the error message or the R console output, and, if you can share them, the two ePubs.
