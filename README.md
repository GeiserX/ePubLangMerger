<p align="center">
  <img src="https://raw.githubusercontent.com/GeiserX/ePubLangMerger/main/docs/images/banner.svg" alt="ePubLangMerger" width="900"/>
</p>

<p align="center">
  <a href="https://github.com/GeiserX/ePubLangMerger/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/GeiserX/ePubLangMerger/ci.yml?style=flat-square&logo=github&label=CI" alt="CI"></a>
  <a href="https://hub.docker.com/r/drumsergio/epublangmerger"><img src="https://img.shields.io/docker/pulls/drumsergio/epublangmerger?style=flat-square&logo=docker&logoColor=white" alt="Docker Pulls"></a>
  <a href="https://github.com/GeiserX/ePubLangMerger/stargazers"><img src="https://img.shields.io/github/stars/GeiserX/ePubLangMerger?style=flat-square&logo=github" alt="Stars"></a>
  <a href="https://github.com/GeiserX/ePubLangMerger/releases/latest"><img src="https://img.shields.io/github/v/release/GeiserX/ePubLangMerger?style=flat-square&logo=github" alt="Release"></a>
  <a href="https://github.com/GeiserX/ePubLangMerger/blob/main/LICENSE"><img src="https://img.shields.io/github/license/GeiserX/ePubLangMerger?style=flat-square" alt="License"></a>
</p>

<p align="center">
  <strong>Merge two ePub files in different languages into a single bilingual ebook for parallel reading.</strong>
</p>

---

ePubLangMerger is an R/Shiny web application that merges two ePub files of the same book, each in a different language, into one bilingual ePub. It places every paragraph and heading of the second language right after the matching one in the first, so you read both versions line by line. It runs in Docker.

## Features

- Pairs the `<p>` and `<h1>` to `<h5>` elements of both ePubs and interleaves them as XML siblings.
- Names the merged file from the input filenames and their language codes.
- Within one browser session, hands back the cached book for any pair that gives the same output name, without a new merge.
- Web UI: upload two ePub files, click "Go!" and download the result.
- Command-line mode: `script.R` does the same merge without the UI, for scripts and batch runs.
- Adds a `_2` suffix to every `id` attribute from the second ePub, so XHTML IDs never collide.

## Quick start

You need Docker.

```bash
curl -fsSLO https://raw.githubusercontent.com/GeiserX/ePubLangMerger/main/docker-compose.yml
docker compose up -d
```

Open http://localhost:3838. Manual install without Docker: [getting started](https://geiserx.github.io/ePubLangMerger/getting-started/#manual-installation-without-docker).

## Documentation

The docs are at [geiserx.github.io/ePubLangMerger](https://geiserx.github.io/ePubLangMerger/).

- [Getting started](https://geiserx.github.io/ePubLangMerger/getting-started/): prerequisites, Docker and manual install, first run.
- [Usage](https://geiserx.github.io/ePubLangMerger/usage/): the web UI, the command line and the filename convention.
- [How it works](https://geiserx.github.io/ePubLangMerger/how-it-works/): extract, parse, merge, reassemble.
- [Troubleshooting](https://geiserx.github.io/ePubLangMerger/troubleshooting/): the limits of the merge and what they look like.
- [Development](https://geiserx.github.io/ePubLangMerger/development/): tests, the image build and releases.

Contributions: see [CONTRIBUTING.md](https://github.com/GeiserX/ePubLangMerger/blob/main/CONTRIBUTING.md).

## Related projects

- [AskePub](https://github.com/GeiserX/AskePub): Telegram bot that annotates ePubs with GPT-4
- [epub-and-vtt-to-llm](https://github.com/GeiserX/epub-and-vtt-to-llm): fine-tunes LLMs on ePub and subtitle text

## License

[GPL-3.0-or-later](https://github.com/GeiserX/ePubLangMerger/blob/main/LICENSE)
