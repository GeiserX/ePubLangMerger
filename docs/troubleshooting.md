# Troubleshooting

## Chapters are missing or paired with the wrong chapter

- **Cause:** the tool pairs the XHTML chapter files inside `OEBPS/` by position, not by name: the first file of one ePub with the first file of the other, and so on. Both ePubs need the same number of chapter files in the same order.
- **Fix:** use two editions built the same way (same publisher and same conversion tool), so the chapter files line up.

## The end of a chapter is in one language only

- **Cause:** paragraph and heading counts differ between the two languages. For each tag, the tool pairs only as many elements as the shorter chapter has. Unpaired first-language elements stay in the output; unpaired second-language elements are dropped.
- **Fix:** none in the tool; the merge is positional. Check that both editions split paragraphs the same way.

## Quotes, lists or boxes are not merged

- **Cause:** only `<p>` and `<h1>` through `<h5>` elements are merged. The tool skips other block elements such as `<blockquote>`, `<div>` and `<ul>`.
- **Fix:** none today; those elements appear in the first language only.

## The reader shows the title or language of the first ePub

- **Cause:** the tool does not modify the ePub's OPF metadata (title, language, etc.).
- **Fix:** edit the metadata afterwards with an ePub editor such as Calibre.

## Reporting a bug

Open an issue at https://github.com/GeiserX/ePubLangMerger/issues with the two input filenames, how you ran the tool (Docker, R or `script.R`), the error message or the R console output, and, if you can share them, the two ePubs.
