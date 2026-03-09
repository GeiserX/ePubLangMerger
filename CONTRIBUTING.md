# Contributing to ePubLangMerger

Thanks for your interest in contributing. This guide covers setup, running, and submitting changes.

## Development Setup

### Prerequisites

- R (>= 3.5) with the packages listed in the README (`shiny`, `XML`, `stringr`, `readr`, `Rcompression`)
- Docker and Docker Compose (for containerized development)

### Local Development

1. Clone the repository:

   ```bash
   git clone https://github.com/GeiserX/ePubLangMerger.git
   cd ePubLangMerger
   ```

2. Install R dependencies (from an R session):

   ```r
   install.packages(c("shiny", "XML", "stringr", "readr"))
   devtools::install_github("omegahat/Rcompression")
   ```

3. Run the app:

   ```r
   shiny::runApp(".", port = 3838)
   ```

   The app will be available at `http://localhost:3838`.

### Docker Development

1. Build and run with Docker Compose:

   ```bash
   docker compose up --build
   ```

2. Or build manually:

   ```bash
   docker build -t epublangmerger .
   docker run -p 3838:3838 epublangmerger
   ```

## Submitting Changes

### Pull Request Guidelines

- One feature or fix per PR.
- Test locally before submitting (both the Shiny app and the Docker build).
- Write a clear PR description explaining what changed and why.
- Keep commits focused and well-described.

### Code Style

- R code: 2-space indentation.
- Use `<-` for assignment, not `=`.
- Keep functions focused and reasonably sized.
- Comment non-obvious logic.

## Reporting Issues

Use the GitHub issue templates for bug reports and feature requests.
