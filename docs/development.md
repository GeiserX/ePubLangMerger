# Development

## Run from a checkout

Clone the repository and install the R packages as in [Getting started](getting-started.md#manual-installation-without-docker), then start the app from the repository root:

```r
shiny::runApp(".", port = 8080)
```

The code is four files: `ui.R` (the page), `server.R` (upload, merge and download), `utils.R` (`makeSibling` and `deriveOutputName`, shared by the app and the script) and `script.R` (the [command line](usage.md#command-line-batch)).

## Test

```bash
Rscript -e 'install.packages(c("testthat", "XML"), repos = "https://cloud.r-project.org/")'
Rscript -e 'testthat::test_dir("tests/testthat")'
```

The tests cover `deriveOutputName` and `makeSibling` in `utils.R`. Two `makeSibling` tests call `skip_on_ci()`: the XML package's in-place node edits crash with `free(): invalid pointer` on the CI runners, so those two run only on your machine.

## Build the image

```bash
docker build -t epublangmerger .
```

The image is `rocker/shiny:4.6` with the R packages installed and `server.R`, `ui.R`, `utils.R` and `www/` copied in, built for `linux/amd64` only. `script.R` and `docs/` are not in it.

Every pull request runs `test` and `docker-build` from `ci.yml`, and the strict docs build from `docs.yml`.

## Release

1. Change the image tag in `docker-compose.yml` and in [Getting started](getting-started.md#docker) to the new version, and merge.
2. Push a tag `vX.Y.Z` on `main`. Never move an existing tag.
3. The Release workflow creates the GitHub release with generated notes, pushes `drumsergio/epublangmerger:X.Y.Z` and `latest` to Docker Hub for `linux/amd64`, and copies `README.md` to the Docker Hub description.

## Docs

The site is built by MkDocs Material from `docs/` and `mkdocs.yml`:

```bash
pip install -r docs/requirements-docs.txt
mkdocs build --strict
```

The same strict build runs on every pull request, and a push to `main` that changes the docs deploys the site. How to send a change: [CONTRIBUTING.md](https://github.com/GeiserX/ePubLangMerger/blob/main/CONTRIBUTING.md).
