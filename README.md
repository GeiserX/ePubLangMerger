<p align="center">
  <img src="docs/images/banner.svg" alt="ePubLangMerger banner" width="900"/>
</p>

<p align="center">
  <a href="https://www.r-project.org/"><img src="https://img.shields.io/badge/R-%3E%3D%203.5-276DC3?logo=r&logoColor=white" alt="R"></a>
  <a href="https://shiny.posit.co/"><img src="https://img.shields.io/badge/Shiny-Web%20App-4479A1?logo=rstudio&logoColor=white" alt="Shiny"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-LGPL--3.0-blue.svg" alt="License: LGPL-3.0"></a>
  <a href="https://github.com/GeiserX/ePubLangMerger/stargazers"><img src="https://img.shields.io/github/stars/GeiserX/ePubLangMerger?style=flat" alt="Stars"></a>
</p>

---

**ePubLangMerger** is an R/Shiny application that takes two ePub files -- each in a different language -- and merges them into a single bilingual ePub. Every paragraph and heading from the second language is inserted as an XML sibling directly after the corresponding element in the first language, producing an interleaved, side-by-side reading experience.

## Features

- **Paragraph-level merging** -- Pairs `<p>` and `<h1>`--`<h5>` elements across both ePubs and interleaves them as XML siblings.
- **Intelligent output naming** -- Automatically generates the merged filename from the input filenames and their language codes.
- **Caching** -- Previously merged files are detected and served instantly without reprocessing.
- **Web UI** -- Upload two ePub files through a clean Shiny interface, click "Go!", and download the result.
- **Batch / CLI mode** -- `script.R` provides a standalone, non-interactive version for scripting and automation.
- **Duplicate ID resolution** -- Appends a `_2` suffix to all `id` attributes from the second ePub to prevent XHTML ID collisions.

## Prerequisites

| Dependency | Purpose |
|---|---|
| [R](https://cran.r-project.org/) (>= 3.5) | Runtime |
| [shiny](https://cran.r-project.org/package=shiny) | Web application framework |
| [XML](https://cran.r-project.org/package=XML) | XHTML parsing and manipulation |
| [stringr](https://cran.r-project.org/package=stringr) | Filename string operations |
| [readr](https://cran.r-project.org/package=readr) | File I/O for cached results |
| [Rcompression](https://github.com/omegahat/Rcompression) | ePub (ZIP) creation |

> **Note:** `Rcompression` is not on CRAN. Install it from GitHub (see below).

## Installation

```bash
git clone https://github.com/GeiserX/ePubLangMerger.git
cd ePubLangMerger
```

Install R dependencies:

```r
install.packages(c("shiny", "XML", "stringr", "readr"))
devtools::install_github("omegahat/Rcompression")
```

## Usage

### Web UI (Shiny)

Launch the Shiny app from R:

```r
shiny::runApp(".", port = 8080, host = "0.0.0.0", launch.browser = TRUE)
```

1. Upload the **first language** ePub (this language will appear first in each paragraph pair).
2. Upload the **second language** ePub.
3. Click **Go!**.
4. Download the merged bilingual ePub.

### Command Line (Batch)

Edit the variables at the top of `script.R` to set your input directory and filenames, then run:

```bash
Rscript script.R
```

This mode is useful for automated pipelines or bulk processing.

## Filename Convention

The tool expects input filenames in the format `Title_LangCode.epub` (e.g., `MyBook_EN.epub`, `MyBook_ES.epub`). The merged output is named by combining both language codes: `MyBook_EN_ES.epub`. An optional trailing segment (e.g., a date) is preserved when present.

## How It Works

1. **Extract** -- Both ePub files are unzipped to reveal their internal XHTML chapter files (in `OEBPS/`).
2. **Parse** -- Each `.xhtml` file is parsed into an XML DOM tree.
3. **Merge** -- For every chapter, paragraphs (`<p>`) and headings (`<h1>`--`<h5>`) from the second language are inserted as siblings immediately after their corresponding elements in the first language. Duplicate `id` attributes are suffixed with `_2`.
4. **Reassemble** -- The modified XHTML files are saved back, the directory structure from the first ePub is copied into a new folder, and the whole structure is re-compressed into a valid `.epub` file using `Rcompression::zip`.

## Limitations

- Both ePubs must share the same internal structure: identical number of XHTML chapter files with matching filenames inside `OEBPS/`.
- Paragraph and heading counts should match across languages. When they differ, only the minimum overlapping count is merged; extra elements in the longer file are left untouched (not duplicated).
- Only `<p>` and `<h1>` through `<h5>` elements are merged. Other block-level elements (e.g., `<blockquote>`, `<div>`, `<ul>`) are not processed.
- The tool does not modify the ePub's OPF metadata (title, language, etc.).

## License

This project is licensed under the [GNU Lesser General Public License v3.0](LICENSE).
