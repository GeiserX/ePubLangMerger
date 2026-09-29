# Troubleshooting

## Chapters are missing or paired with the wrong chapter

- **Cause:** both ePubs need the same internal structure, meaning the same number of XHTML chapter files with matching filenames inside `OEBPS/`.
- **Fix:** use two editions built the same way (same publisher and same conversion tool), so the chapter files line up.

## The end of a chapter is in one language only

- **Cause:** paragraph and heading counts differ between the two languages. The tool merges only as many elements as the shorter file has; the extra elements of the longer file stay as they are, in one language.
- **Fix:** none in the tool; the merge is positional. Check that both editions split paragraphs the same way.

## Quotes, lists or boxes are not merged

- **Cause:** only `<p>` and `<h1>` through `<h5>` elements are merged. The tool skips other block elements such as `<blockquote>`, `<div>` and `<ul>`.
- **Fix:** none today; those elements appear in the first language only.

## The reader shows the title or language of the first ePub

- **Cause:** the tool does not modify the ePub's OPF metadata (title, language, etc.).
- **Fix:** edit the metadata afterwards with an ePub editor such as Calibre.

## Reporting a bug

Open an issue at https://github.com/GeiserX/ePubLangMerger/issues with the two input filenames, how you ran the tool (Docker, R or `script.R`), the error message or the R console output, and, if you can share them, the two ePubs.
