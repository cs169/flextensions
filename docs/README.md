# Flextensions Documentation

This directory contains the source files for the Flextensions documentation site, served at [berkeley-cdss.github.io/flextensions](https://berkeley-cdss.github.io/flextensions).

The site is built with [Jekyll](https://jekyllrb.com/) and deployed automatically via GitHub Pages from the `docs/` directory on `main`.

## Local Development

```bash
cd docs
bundle install
bundle exec jekyll serve
```

Then visit http://localhost:4000/flextensions/.

## Directory Structure

- `*.md` — Documentation pages (each has YAML front matter with `title` and `permalink`)
- `_config.yml` — Jekyll configuration
- `api/` — Swagger/OpenAPI reference (static HTML, not processed by Jekyll)
- `img/` — Images used in documentation
- `_site/` — Generated output (gitignored)

## Adding a Page

Create a new `.md` file with front matter:

```markdown
---
title: Your Page Title
permalink: /your-page/
---

Content here...
```

Internal links should use absolute paths starting with `/flextensions/`, e.g. `[Developers](/flextensions/developers/)`.

## CI

The `Docs Build` workflow (`.github/workflows/docs.yml`) validates the Jekyll build and checks for broken internal links on PRs that touch `docs/`.
