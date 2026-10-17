(sec_myst_basics)=
# MyST Markdown Basics

MyST Markdown is Markdown with extra features for technical documentation. A MyST page is still
plain text: write the content first, then use headings and links to make it easy to read and
navigate.

This tutorial introduces the syntax you need for a first page. It also shows how to add a diagram,
link to a section, add a footnote, and cite a source. The [MyST reference](language-reference.md)
covers these and other features in more detail.

## 1. Write paragraphs and format text

Separate paragraphs with a blank line. Use asterisks for emphasis and backticks for short code or
technical names:

```markdown
Hermesbaby builds documentation from Markdown files.

Use **bold** for emphasis, *italics* for a lighter emphasis, and `inline code` for names.
```

For details, see {ref}`ref_paragraphs` in the reference.

## 2. Add headings

Use `#` for the page title and add more `#` characters for sections. Keep heading levels in order:

```markdown
# Getting Started

## Install Hermesbaby

### Check the installation
```

Each page should have one title. Do not skip a level, such as going from `##` directly to `####`.
See {ref}`ref_headings` for heading syntax and levels.

## 3. Make lists

Use asterisks for unordered lists and numbers for steps:

```markdown
* Source files are plain text.
* Pages can link to one another.

1. Write a page.
2. Build the documentation.
3. Check the rendered result.
```

Indent nested items by two spaces.
See {ref}`ref_lists` for list syntax and variants.

## 4. Add links and code

Use standard Markdown links for websites and other pages:

```markdown
[Hermesbaby on PyPI](https://pypi.org/project/hermesbaby/)
[Another page](../12-Glossary/index.md)
```
See {ref}`ref_links` for external, page-relative, and labeled links.

Use backticks for a command or a short code example, and fenced blocks for longer examples. Add a
language name after the opening fence when syntax highlighting is useful:

````markdown
Run `hb html` to build the documentation.

```python
print("Hello, documentation!")
```
````
See {ref}`ref_code` for inline code, fenced blocks, and code-block options.

## 5. Connect pages

When your documentation has more than one page, list child pages in a `{toctree}` on the section's
`index.md`:

````markdown
```{toctree}
:maxdepth: 1

getting-started
reference
```
````

Entries are paths relative to the current file and omit the `.md` extension. A folder's `index.md`
is its entry point.
See {ref}`ref_toctree` for toctree options and {ref}`ref_document_structure` for page and folder
structure.

## 6. Add a DrawIO figure

Save the diagram as a `.drawio` file in a `_figures/` folder next to the page, then embed it with
the `{drawio-figure}` directive:

````markdown
```{drawio-figure} _figures/system_overview.drawio

System overview.
```
````

For a static exported `.drawio.svg`, use `{figure}` instead. See {ref}`ref_drawio_figures` and
{ref}`ref_figures` for figure formats and options.

## 7. Link to a section

Add a label immediately before the heading you want to link to, then use `{ref}` where the link
should appear:

````markdown
(sec_installation)=
## Installation

Install Hermesbaby before building the documentation.

See {ref}`sec_installation` for installation instructions.
````

Labels are stable identifiers; use lowercase words separated by underscores. To refer to a figure
by its number, use `{numref}` with the figure label, such as `{numref}`fig_system_overview``.
See {ref}`ref_cross_references` for label and reference syntax.

## 8. Add a footnote

Put a footnote marker where the extra detail belongs and define its text elsewhere on the page:

```markdown
MyST supports footnotes[^myst-note].

[^myst-note]: Use footnotes for useful asides that would interrupt the main text.
```
See {ref}`ref_footnotes` for footnote syntax and guidance.

## 9. Cite a source

Add a BibTeX entry to `docs/bibliography.bib`, then cite its key in your text with `{cite}`:

````markdown
<!-- Add this entry to docs/bibliography.bib -->
```bibtex
@online{myst_docs,
  title = {MyST Markdown Documentation},
  author = {{Executable Books Project}},
  url = {https://myst-parser.readthedocs.io/}
}
```
````

```markdown
MyST extends Markdown for technical documentation {cite}`myst_docs`.
```

To display the cited sources on a bibliography page, add the `{bibliography}` directive:

````markdown
```{bibliography}
```
````

The project's `docs/99-Appendix/04-Bibliography/index.md` is an example. See
{ref}`ref_citations` for citations and bibliography display.

## 10. Quote a passage

Start a line with `>` to format it as a blockquote:

```markdown
> Clear documentation helps readers understand a system.
```

See {ref}`ref_blockquotes` for blockquote syntax.

## Next steps

Build and preview the page with [Hermesbaby](features.md). Once the basics feel familiar, continue
to the [complete MyST reference](language-reference.md) for more options and examples.
