---
hide:
  - navigation
---

# ePubLangMerger { .elm-visually-hidden }

<p align="center">
  <img src="images/banner.svg" alt="ePubLangMerger: two languages, one book, side by side" width="100%">
</p>

<p align="center">
  <a href="https://hub.docker.com/r/drumsergio/epublangmerger"><img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/drumsergio/epublangmerger?style=flat-square&logo=docker"></a>
  <a href="https://github.com/GeiserX/ePubLangMerger/stargazers"><img alt="GitHub Stars" src="https://img.shields.io/github/stars/GeiserX/ePubLangMerger?style=flat-square&logo=github"></a>
  <a href="https://github.com/GeiserX/ePubLangMerger/releases"><img alt="Release" src="https://img.shields.io/github/v/release/GeiserX/ePubLangMerger?style=flat-square"></a>
  <a href="https://github.com/GeiserX/ePubLangMerger/blob/main/LICENSE"><img alt="License: GPL-3.0-or-later" src="https://img.shields.io/github/license/GeiserX/ePubLangMerger?style=flat-square"></a>
</p>

---

**ePubLangMerger** takes two ePub files of the same book in two languages and makes one ePub in which every paragraph and heading of the second language comes right after the matching one in the first. Reading a translation next to the original otherwise means two books open at once and finding your place twice on every page, and bilingual editions exist for few books. It is a small web page that runs in Docker, plus a script for batch runs. Start with [Getting started](getting-started.md), then [Usage](usage.md).

<div class="grid cards" markdown>

-   :material-docker: **[Getting started](getting-started.md)**

    ---

    Start the container with the shipped compose file, or run the app from R without Docker.

-   :material-book-open-page-variant-outline: **[Usage](usage.md)**

    ---

    Upload the two ePubs, the language you want first as the first file, click Go! and download the merged book.

-   :material-console: **[Command line](usage.md#command-line-batch)**

    ---

    `script.R` merges a pair without the web page, for scripts and many books in a row.

-   :material-alert-circle-outline: **[Troubleshooting](troubleshooting.md)**

    ---

    Why pairs drift apart, what is not merged, and what to put in a bug report.

</div>

## What it does

- Puts each `<p>` and `<h1>` to `<h5>` of the second language right after the element in the same position in the first language, chapter by chapter.
- Keeps the rest of the first ePub as it is: its images, styles, table of contents and metadata.
- Adds `_2` to every `id` it copies from the second ePub, so the copies do not repeat the ids of the first language.
- Names the result from the two file names: `MyBook_EN.epub` and `MyBook_ES.epub` give `MyBook_EN_ES.epub`. See [the filename convention](usage.md#filename-convention).
- Merging the same pair again in the same browser session returns the first result without redoing the work.

## How it runs

- One container, `drumsergio/epublangmerger`, pinned to a release tag in the shipped `docker-compose.yml`, built for `linux/amd64` only. It serves the page on port 3838 with Shiny Server.
- Without Docker: R 4.x with the `shiny`, `XML`, `stringr` and `Rcompression` packages, on the port you choose. See [Getting started](getting-started.md#manual-installation-without-docker).
- A merge unpacks both books, edits the chapter files of the first and zips the result. [How it works](how-it-works.md) has the four steps.

## What it does not do

- It does not match paragraphs by meaning. It pairs them by position, so two editions that split paragraphs differently drift apart. See [Troubleshooting](troubleshooting.md).
- Text outside `<p>` and `<h1>` to `<h5>` elements, such as list items and table cells, stays in the first language only.
- It reads chapters only from the `OEBPS/` folder, and only files whose names end in `.xhtml`.
- It does not change the book's title or language in its metadata: a reader shows those of the first ePub.
- It accepts files of up to 50 MB each, and it has no login: anyone who can reach port 3838 can use it.

## Privacy

- The books stay on the machine that runs the app. It makes no network requests of its own.
- The unpacked books and the merged file sit in a temporary folder for your browser session and are deleted when the session ends.

## Getting help

- Something broken: read [Troubleshooting](troubleshooting.md), then open an [issue](https://github.com/GeiserX/ePubLangMerger/issues) with the details it lists.
- A security problem: follow the [security policy](https://github.com/GeiserX/ePubLangMerger/blob/main/SECURITY.md), never a public issue.
- What changed between versions: the [releases on GitHub](https://github.com/GeiserX/ePubLangMerger/releases).
- Running the tests, building the image and releasing: [Development](development.md).
- Other ePub tools: [AskePub](https://github.com/GeiserX/AskePub), a Telegram bot that annotates ePubs with GPT-4, and [epub-and-vtt-to-llm](https://github.com/GeiserX/epub-and-vtt-to-llm), which fine-tunes LLMs on ePub and subtitle text.

## License

ePubLangMerger is released under the [GPL-3.0-or-later](https://github.com/GeiserX/ePubLangMerger/blob/main/LICENSE) license. It is built on [Shiny](https://shiny.posit.co/) and the [XML](https://cran.r-project.org/package=XML) package.
