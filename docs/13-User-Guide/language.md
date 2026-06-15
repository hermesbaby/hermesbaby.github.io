(sec_authoring_guide)=

# MyST Markdown

This documentation uses **MyST Markdown** — a superset of CommonMark that adds directives,
roles, and cross-referencing to plain Markdown. This guide walks through every syntax construct
used in this project, starting from the basics you'll need every day and ending with the more
specialized features.

---

## Document Structure

Every file is a self-contained page. The minimal skeleton looks like this:

```markdown
(sec_my_section_label)=
# My Page Title

First paragraph of content.
```

### Table of Contents: `{toctree}`

Every section index file defines which child pages appear under it using the `{toctree}`
directive:

````markdown
```{toctree}
:maxdepth: 2

01-Introduction/index
02-Setup/index
03-Reference/index
```
````

Paths are relative to the current file and omit the `.md` extension. The `:hidden:` option keeps
the entries out of the rendered page body while still building the navigation tree.

---

## Headings

Use ATX-style headings. Each file should have exactly one H1 (`#`) as its page title. Subsequent
levels provide section hierarchy:

```markdown
# Page Title (H1 — one per file)
## Major Section (H2)
### Subsection (H3)
#### Minor subsection (H4)
```

```{note}
Heading levels also determine navigation depth. Avoid skipping levels (e.g. jumping from `##`
to `####`). Headings automatically generate anchor links, but prefer explicit
[cross-reference labels](#links) when linking to a section from another file.
```

---

## Paragraphs and Basic Inline Formatting

Separate paragraphs with a blank line. Inline formatting:

| Effect | Syntax | Result |
|--------|--------|--------|
| Bold | `**text**` | **text** |
| Italic | `*text*` | *text* |
| Inline code | `` `code` `` | `code` |

Inline code (backtick) is the most common inline element — use it for identifiers, file names,
configuration keys, and technical terms.

---

## Lists

### Unordered Lists

Use `*` as the bullet marker (see [Conventions](conventions.md) for the rationale):

```markdown
* System Engineering
* Software Engineering
* Hardware Engineering
```

### Ordered Lists

```markdown
1. Define the system boundary
2. Identify stakeholders
3. Elicit requirements
```

### Nested Lists

Indent with two spaces to nest:

```markdown
* Engineering disciplines
  * System Engineering
  * Software Engineering
* Management disciplines
  * Risk Management
```

```{note}
Keep nesting shallow. Two levels is usually enough; three or more levels is a sign the content
wants to be a subsection instead.
```

### Task Lists

Checkbox lists mark completion status (used primarily in requirement checklists):

```markdown
* [x] Done
* [ ] Not yet done
```

---

## Links

### External and Page-Relative Links

Standard Markdown link syntax:

```markdown
[Link text](https://example.com)
[Relative page link](../other-folder/index.md)
```

For bare URLs that should be clickable as-is, use angle brackets:

```markdown
<https://mystmd.org>
```

### Cross-Reference Labels

This is the primary way to link between pages in MyST. First, place a **label** immediately
before the heading or element you want to target:

```markdown
(sec_contribution_guide)=
## Contribution Guide
```

Then reference it from anywhere using the `{ref}` role:

```markdown
See {ref}`sec_contribution_guide` for details.
```

The rendered output becomes a hyperlink with the section's title as text.

For numbered figures, use `{numref}` instead:

```markdown
The diagram {numref}`fig_my_diagram` shows the architecture.
```

See [Conventions](conventions.md) for the full label naming policy.

---

## Figures

All figures — raster images, exported SVGs, and DrawIO source files — live in a `_figures/`
subfolder next to your `index.md` and are embedded with a directive, not plain Markdown image
syntax. Directives give you captions, cross-reference labels, and layout options.

### `{figure}` — Images and Exported SVGs

Use `{figure}` for any static image file (`.png`, `.svg`, `.jpg`, `.drawio.svg`):

````markdown
(fig_my_diagram)=
```{figure} _figures/my-diagram.png
:align: center
:width: 80%

Caption text that appears below the image.
```
````

The `(fig_my_diagram)=` line directly above the directive creates an anchor so you can
cross-reference this figure from anywhere:

```markdown
As shown in {numref}`fig_my_diagram`, the system has three layers.
```

Common options:

| Option | Example | Effect |
| ------ | ------- | ------ |
| `:align:` | `center` | Horizontal alignment (`left`, `center`, `right`) |
| `:width:` | `80%` or `15cm` | Rendered width |
| `:scale:` | `60%` | Scale relative to original size |
| `:alt:` | `"a graph"` | Accessibility / screen-reader text |
| `:name:` | `fig_my_name` | Inline label, alternative to the `(label)=` prefix |

### DrawIO File Formats Compared

DrawIO diagrams can be committed and embedded in three ways. Each has different trade-offs for
git, IDE preview, and build complexity:

| Aspect | `.drawio.png` | `.drawio.svg` | `.drawio` |
| ------ | :-----------: | :-----------: | :-------: |
| Directive | `{figure}` | `{figure}` | `{drawio-figure}` |
| Git diff | binary — no diff | text-based XML diff | text-based XML diff |
| Git LFS needed | recommended | no | no |
| IDE / GitHub preview | instant raster preview | renders as vector | renders as diagram (GitHub) |
| Vector / scalable | no | yes | yes |
| Print / high-DPI quality | limited by export resolution | crisp at any size | crisp at any size |
| Build-time dependency | none | none | DrawIO plugin required |
| Multi-page support | one export per page | one export per page | `:page-name:` selects page |
| Hyperlinks in diagram | lost on export | lost on export | preserved |
| Embedded source in file | yes (in PNG metadata) | yes (in SVG XML) | the file is the source |

**`.drawio.png`** — Simplest to preview everywhere but bloats the repository over time and
produces binary diffs. Export at 2× or higher resolution to stay readable on high-DPI screens.
Use only when the build environment has no SVG renderer or when a raster is explicitly required.

**`.drawio.svg`** — Best default for most diagrams. Scales losslessly, diffs as text, previews
in the IDE and on GitHub, and requires no build plugin. The SVG file also carries the DrawIO
XML source in an embedded attribute, so the original diagram is always recoverable. Use `{figure}`
to embed it:

````markdown
```{figure} _figures/architecture.drawio.svg
:align: center
:width: 90%

System context overview.
```
````

**`.drawio`** — Use when you need multi-page navigation or hyperlinks between diagram nodes. The
`{drawio-figure}` plugin renders the raw source server-side during the build.

### `{drawio-figure}` — DrawIO Source Diagrams

Use `{drawio-figure}` when you want to embed a `.drawio` file directly — the plugin renders it
server-side and preserves navigation links between diagram pages:

````markdown
(fig_architecture_overview)=
```{drawio-figure} _figures/architecture.drawio
:page-name: Overview

Caption text.
```
````

The `:page-name:` option selects which tab of the multi-page DrawIO file to render. If the file
has only one page the option can be omitted.

```{note}
If you exported a DrawIO diagram as a static `.drawio.svg` file, use the plain `{figure}`
directive instead — `{drawio-figure}` expects the raw `.drawio` XML source.
```

---

## Tables

### Pipe Tables

Standard Markdown pipe syntax works for simple tables with short, plain-text cells:

```markdown
| Version | Change | Reviewer |
| ------- | ------ | -------- |
| 1.0 | Initial release | J. Smith |
| 1.1 | Added appendix | A. Jones |
```

#### Column Alignment

Control per-column alignment with colons in the separator row:

| Alignment | Separator syntax | Typical use |
| --------- | ---------------- | ----------- |
| Left | `:---` | Text, names, descriptions (default) |
| Center | `:---:` | Short labels, status values, icons |
| Right | `---:` | Numbers, versions, sizes |

Example combining all three:

```markdown
| Name | Status | Count |
| :--- | :----: | ----: |
| Alpha | active | 42 |
| Beta | draft | 7 |
```

Use pipe tables when the source reads well at a glance — two or three short columns. For longer
cell content, mixed inline markup, or more than three columns, use `{list-table}` instead.

### `{list-table}` Directive

`{list-table}` is more structured and handles long cell content reliably:

````markdown
```{list-table}
:header-rows: 1

* - Version
  - Change
  - Reviewer
  - Comment
* - 1.0
  - Initial release
  - J. Smith
  - Approved
```
````

Each row starts with `* -` and subsequent cells are indented two spaces followed by `-`. The
`:header-rows: 1` option makes the first row a header. Cells can contain any inline markup,
code spans, or even nested lists.

---

## Code

### Inline Code

Use single backticks for short code snippets, commands, or technical terms inline with text:

```markdown
Run `git tag -m <msg> <tagname>` to create an annotated tag.
```

### Fenced Code Blocks

Use triple backticks with an optional language identifier for multi-line code:

````markdown
```python
def greet(name: str) -> str:
    return f"Hello, {name}!"
```
````

Common language tags used in this project: `python`, `bash`, `json`, `yaml`, `xml`, `cpp`,
`javascript`, `sql`, `console`, `text`.

For a plain block without highlighting, omit the language tag.

### `{code-block}` Directive

The directive form gives you additional options (line numbers, highlighted lines, captions). Use
it when you need those features; otherwise the fenced form is simpler:

````markdown
```{code-block} json
:linenos:

{
    "key": "value"
}
```
````

### Nesting Code Inside Directives

If a code block appears *inside* a directive, wrap the outer directive with four backticks so the
three-backtick fence inside is not misread:

`````markdown
````{note}
Here is an example:

```python
print("hello")
```
````
`````

---

## Blockquotes

Use `>` for quotations from external sources:

```markdown
> A system is an arrangement of parts or elements that together exhibit behavior
> or meaning that the individual parts do not.
> (Quote from {cite}`iso_24748_1_2024`)
```

---

## Admonitions

Admonitions are colored call-out boxes that use the **directive** syntax.

### Standard Admonition Types

````markdown
```{note}
Use `note` for neutral supplemental information.
```

```{hint}
Use `hint` to give the reader a helpful tip.
```

```{important}
Use `important` for information the reader must not overlook.
```

```{attention}
Use `attention` as a lighter-weight alternative to `warning`.
```

```{warning}
Use `warning` when incorrect actions could cause problems.
```

```{danger}
Use `danger` for irreversible or destructive actions.
```
````

```{hint}
All admonition types accept any MyST content inside them: lists, code blocks, inline roles, and
even nested directives.
```

### Generic `{admonition}` with Custom Title

When you want a custom title, use the generic `{admonition}` directive and set `:class:` to a
standard type name:

````markdown
```{admonition} Caveat: Build Environment Configuration
:class: warning

The `commit ID` of the source code must be recorded at build time.
```
````

### `{todo}` — Editorial Placeholders

Use `{todo}` to mark content that still needs to be written. Rendered visibly in draft builds;
can be suppressed in release builds. Can carry a title:

````markdown
```{todo}
Describe the release branching strategy.
```

```{todo} Describe Content Creation Process
Explain how to manage branches and create content.
```
````

---

## Directives

Directives are the core building block of MyST. The syntax is a fenced code block where the
language is a directive name in curly braces:

````markdown
```{directive-name} optional-argument
:option-key: option-value

Content body (optional).
```
````

The **argument** goes on the same line as the directive name. **Options** are `:key: value` lines
immediately after the opening fence, before any blank line. The **content** comes after any
options and an optional blank line.

### Figures and Images

Use `{figure}` for images that need a caption or a cross-reference label:

````markdown
(fig_my_diagram)=
```{figure} _figures/my-diagram.drawio.svg
:align: center
:width: 80%

Caption text that appears below the image.
```
````

Common figure options:

| Option | Example | Effect |
|---|---|---|
| `:align:` | `center` | Horizontal alignment |
| `:width:` | `80%` or `15cm` | Rendered width |
| `:scale:` | `60%` | Scale relative to original |
| `:alt:` | `"a graph"` | Accessibility text |
| `:name:` | `fig_my_name` | Alternative to the `(label)=` syntax |

The line `(fig_my_diagram)=` directly above the directive creates an anchor for cross-referencing.

### Draw.io Diagrams

For `.drawio` source files with embedded navigation links, use `{drawio-figure}`:

````markdown
```{drawio-figure} _figures/architecture.drawio
:page-name: Overview

Caption text.
```
````

The `:page-name:` option selects which tab of the DrawIO file to render. For static exported
`.drawio.svg` files, use the plain `{figure}` directive instead. See
[Conventions](conventions.md) for details on the two formats.

### UML Diagrams

For PlantUML `.puml` files, use `{uml}`:

````markdown
```{uml} _figures/sequence.puml
:caption: Sequence diagram title
:width: 25cm

```
````

### Code Blocks with Options

The `{code-block}` directive adds options unavailable in plain fenced blocks:

````markdown
```{code-block} python
:linenos:
:emphasize-lines: 3

def greet(name):
    # This line is highlighted
    return f"Hello, {name}!"
```
````

### Glossary

Define terms in a `{glossary}` directive:

````markdown
```{glossary}

My Term
    This is the definition. It can span multiple paragraphs.

Another Term
    Another definition. Refer to related terms with {term}`My Term`.
```
````

### Card

The `{card}` directive renders a bordered box, useful for prominent notices:

````markdown
```{card}
This is a preview of the VITRONIC Engineering Handbook.
The Handbook has not been approved so that there is no released version yet.
```
````

---

## Roles (Inline Directives)

Roles are inline elements that produce rich output. The syntax is:

```
{role-name}`content`
```

### `{ref}` — Internal Cross-References

```markdown
See {ref}`sec_authoring_guide` for details.
```

### `{numref}` — Numbered Figure References

```markdown
The diagram {numref}`fig_my_diagram` shows the architecture.
```

### `{term}` — Glossary Terms

Links a term to its definition in the glossary:

```markdown
The {term}`Digitaler Zwilling` is the core data model.
```

### `{abbr}` — Abbreviations with Expansions

Renders the abbreviation with a tooltip showing the full form:

```markdown
The {abbr}`SoI(System of Interest)` defines the scope.
```

### `{cite}` — Bibliographic Citations

Links to an entry in the bibliography:

```markdown
As defined in {cite}`iso_24748_1_2024`, the lifecycle has six stages.
```

### `{doc}` — Link to Another Document by Path

Links to another page using its file path relative to the project root:

```markdown
See {doc}`/12-Glossary/index` for all terms.
```

### Project-Specific Roles

| Role | Example | Renders as |
|---|---|---|
| `{jira}` | `` {jira}`PJBIO-1060` `` | Link to Jira ticket |
| `{user}` | `` {user}`AMAN` `` | Mention a team member |
| `{repo}` | `` {repo}`biom/BiomechWebGui` `` | Link to repository |
| `{param}` | `` {param}`«component» WebGui` `` | Highlight a parameter |
| `{kbd}` | `` {kbd}`Ctrl+S` `` | Keyboard shortcut: {kbd}`Ctrl+S` |
| `{download}` | `` {download}`_attachments/spec.pdf` `` | File download link |

---

## Definition Lists

For term–definition pairs (API methods, glossary-like content within a page):

```markdown
`method_name(arg)`:
: What the method returns or does.

`another_method()`:
: Another definition. Can span
  multiple lines.
```

The term line ends with `:`, and the definition starts with `:` on the next line.

---

## Footnotes

Place a footnote marker inline, then define it anywhere in the file:

```markdown
This concept[^fn1] is important.

[^fn1]: Full explanation of the concept.
```

The rendered footnote appears at the bottom of the page. Use footnotes for tangential
clarifications that would interrupt the main flow if inlined.

---

### File Frontmatter

Frontmatter is a YAML block between `---` delimiters at the very top of the file. It is optional
but used when needed:

```yaml
---
orphan: true
---
```

The `orphan: true` key suppresses Sphinx warnings for pages not included in any `{toctree}`. Use
it for standalone pages or drafts not yet wired into the navigation. See
[Conventions](conventions.md) for the full policy.

---

## HTML Comments

Use HTML comments to hide editorial notes, disabled content, or temporarily disabled directives
from the rendered output:

```html
<!--
This section is intentionally left blank until the review is complete.
-->
```

Comments also work to disable a directive block:

```html
<!--
```{todo}
Add example project walkthrough
```
-->
```

---

## Alternative Directive Fence Style

Directives can also use `:::` fences instead of backtick fences. The two styles are equivalent —
use whichever you prefer, but be consistent within a file:

```markdown
:::{drawio-figure} _figures/diagrams.drawio
:page-name: Overview
:::
```

The `:::` style is useful when the directive content itself contains backtick fences, avoiding
ambiguity.

---

## Quick Reference

| Element | Syntax | When to use |
|---|---|---|
| Bold | `**text**` | Emphasize important terms or values |
| Italic | `*text*` | Titles of external works, gentle emphasis |
| Inline code | `` `code` `` | File names, identifiers, commands |
| Fenced code | ` ```lang ` | Multi-line code samples |
| Code block (options) | ` ```{code-block} lang ` | Line numbers, highlights, captions |
| Section label | `(sec_name)=` | Before any heading to cross-reference |
| Figure label | `(fig_name)=` | Before `{figure}` directive |
| Cross-reference | `` {ref}`sec_name` `` | Link to a labeled section or figure |
| Numbered fig ref | `` {numref}`fig_name` `` | Reference a numbered figure |
| Page link | `` {doc}`/path/index` `` | Link to another document by path |
| List table | ` ```{list-table} ` | All tabular data |
| Figure | ` ```{figure} path ` | Images with captions |
| Draw.io figure | ` ```{drawio-figure} path ` | Draw.io source diagrams |
| UML | ` ```{uml} path ` | PlantUML diagrams |
| Toctree | ` ```{toctree} ` | Navigation tree in index files |
| Glossary | ` ```{glossary} ` | Term definitions |
| Card | ` ```{card} ` | Bordered notice box |
| Note | ` ```{note} ` | Supplementary information |
| Hint | ` ```{hint} ` | Helpful tip |
| Important | ` ```{important} ` | Must-not-overlook information |
| Attention | ` ```{attention} ` | Must-read before proceeding |
| Warning | ` ```{warning} ` | Hazards or actions that cause problems |
| Danger | ` ```{danger} ` | Irreversible or destructive actions |
| Custom admonition | ` ```{admonition} Title ` | Admonition with a custom title |
| Todo | ` ```{todo} ` | Placeholder for missing content |
| Glossary term | `` {term}`Term` `` | Link to glossary entry |
| Abbreviation | `` {abbr}`ABC(Full Name)` `` | First use of an acronym |
| Citation | `` {cite}`bib-key` `` | Cite a bibliography entry |
| Jira ticket | `` {jira}`PJBIO-1234` `` | Reference a Jira issue |
| User mention | `` {user}`ABC` `` | Mention a team member |
| Repository | `` {repo}`biom/repo-name` `` | Link to a repository |
| Keyboard key | `` {kbd}`Ctrl+C` `` | Keyboard shortcut |
| Footnote | `[^key]` / `[^key]: text` | Supplementary notes |
| Definition list | `` `term`: `` / `: definition` | Term–definition pairs within a page |
| Blockquote | `> text` | Quotations from external sources |
| HTML comment | `<!-- text -->` | Hide editorial notes or disabled content |
