(sec_myst_basics)=
# MyST Markdown Basics

MyST Markdown is Markdown with extra features for technical documentation. A MyST page is still
plain text: write the content first, then use headings and links to make it easy to read and
navigate.

This tutorial introduces the syntax you need for a first page. The [MyST reference](language.md)
covers figures, tables, directives, and other features in more detail.

## 1. Write paragraphs and format text

Separate paragraphs with a blank line. Use asterisks for emphasis and backticks for short code or
technical names:

```markdown
Hermesbaby builds documentation from Markdown files.

Use **bold** for emphasis, *italics* for a lighter emphasis, and `inline code` for names.
```

## 2. Add headings

Use `#` for the page title and add more `#` characters for sections. Keep heading levels in order:

```markdown
# Getting Started

## Install Hermesbaby

### Check the installation
```

Each page should have one title. Do not skip a level, such as going from `##` directly to `####`.

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

## 4. Add links and code

Use standard Markdown links for websites and other pages:

```markdown
[Hermesbaby on PyPI](https://pypi.org/project/hermesbaby/)
[Another page](../12-Glossary/index.md)
```

Use backticks for a command or a short code example, and fenced blocks for longer examples. Add a
language name after the opening fence when syntax highlighting is useful:

````markdown
Run `hb html` to build the documentation.

```python
print("Hello, documentation!")
```
````

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

## Next steps

Build and preview the page with [Hermesbaby](features.md). Once the basics feel familiar, continue
to the [complete MyST reference](language.md) for cross-references, figures, tables, and directives.
