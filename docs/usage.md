# Usage

## Web UI

Start the app with Docker (http://localhost:3838) or from R (http://localhost:8080), as in [Getting started](getting-started.md). Then:

1. Upload the **first language** ePub (this language will appear first in each paragraph pair).
2. Upload the **second language** ePub.
3. Click **Go!**.
4. Download the merged bilingual ePub.

## Command line (batch)

```bash
Rscript script.R <input_dir> <file1.epub> <file2.epub> <output_dir>
```

Example:

```bash
Rscript script.R ./books MyBook_EN.epub MyBook_ES.epub ./output
```

Use it in scripts or to merge many books in a row.

`script.R` is not in the Docker image. Run it from a checkout with the R packages installed, as in [Getting started](getting-started.md#manual-installation-without-docker).

## Filename convention

The tool expects input filenames in the format `Title_LangCode.epub`, for example `MyBook_EN.epub` and `MyBook_ES.epub`. The tool reads the last underscore-separated part of each name as the language code, and the merged file combines both codes: `MyBook_EN_ES.epub`. A name with no underscore gives `<name>_merged.epub`.
