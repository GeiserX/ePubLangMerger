# Getting started

## Prerequisites

| Dependency | Purpose |
|---|---|
| [Docker](https://docs.docker.com/get-docker/) (recommended) | Run the app with no manual dependency management |
| [R](https://cran.r-project.org/) 4.x (the Docker image ships 4.6) | Runtime (manual installation only) |
| [shiny](https://cran.r-project.org/package=shiny) | Web application framework |
| [XML](https://cran.r-project.org/package=XML) | XHTML parsing and manipulation |
| [stringr](https://cran.r-project.org/package=stringr) | Filename string operations |
| [Rcompression](https://github.com/omegahat/Rcompression) | ePub (ZIP) creation |

`Rcompression` is not on CRAN. Install it from GitHub with `remotes` (see below).

## Docker

```bash
curl -fsSLO https://raw.githubusercontent.com/GeiserX/ePubLangMerger/main/docker-compose.yml
docker compose up -d
```

The compose file pins the current release image (`drumsergio/epublangmerger:1.1.1`).

Open http://localhost:3838, upload your two ePub files and download the merged result.

## Manual installation (without Docker)

```bash
git clone https://github.com/GeiserX/ePubLangMerger.git
cd ePubLangMerger
```

Install the R dependencies:

```r
install.packages(c("shiny", "XML", "stringr", "remotes"))
remotes::install_github("omegahat/Rcompression")
```

Launch the Shiny app from R:

```r
shiny::runApp(".", port = 8080, host = "0.0.0.0", launch.browser = TRUE)
```

Then open http://localhost:8080. The steps in the app and the command-line mode are in [Usage](usage.md).
