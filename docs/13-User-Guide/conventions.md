(sec_authoring_conventions)=
# Conventions

The patterns described here have emerged from practical experience writing and maintaining this
documentation. They are **guidelines, not hard rules** — existing pages that deviate are not
wrong, and there are legitimate reasons to break a pattern in a specific context. The goal is
coherence: a reader who jumps between sections should not feel like they are reading different
projects, and a new author should be able to produce something that fits without spending effort
on low-stakes decisions.

When in doubt: follow the existing file closest to what you are writing.

---

## Folder and File Names

### One `index.md` per Folder

Every content folder has a single entry-point file called `index.md` (or `index.rst` for older
sections written in reStructuredText). Sub-pages live in named sub-folders, each with their own
`index.md`.

```text
14-Engineering-Notebooks/
    PJBIO-1060-Crosssections-over-sticks/
        index.md          ← entry point
        _figures/
    Balancer/
        index.md
        01-Introduction-and-Goals/
            index.md
```

**Why:** Sphinx/MyST assembles the navigation tree from `toctree` entries that point to folders.
Using `index.md` everywhere means every path ends the same way, toctree entries are uniform, and
readers who land on a bare folder URL always get the right page.

**Advantage:** The nav hierarchy mirrors the folder hierarchy exactly. Any tool that lists files
alphabetically (file explorer, CI output) immediately shows which file is the section root.

### Numbered Prefixes Define Reading Order

Top-level documentation chapters use two-digit numeric prefixes, zero-padded:
`00-Project-Manual`, `01-Introduction-and-Goals`, …, `12-Glossary`, `99-Appendix`.

Folders that contain **sequential** content (process steps, lifecycle phases) carry a numeric
prefix so that the filesystem order matches the intended reading order:

```text
Appendix/Process_Assessment_Guide/Software_Engineering/
  01_SW_Requirements_Analysis/
  02_SW_Architectural_Design/
  03_SW_Detailed_Design/
```

**Why:** `{toctree}` controls the rendered order, but file explorers, `git diff` output, and
directory listings all sort alphabetically. Numeric prefixes keep both views consistent.

**Alternative:** Rely solely on toctree order and use plain PascalCase folder names. Acceptable
for non-sequential content such as service descriptions or appendix topics where no reading order
applies.

### Hyphens Between Words in Folder Names

Folder names use Title-Case words joined by hyphens:
`Engineering-Notebooks`, `Workflow-and-Collaboration`, `Meeting-Minutes`.

**Why:** Hyphens survive more contexts than spaces (URLs, shell scripts, git paths on all
platforms). Title-case keeps folder names readable in filesystem listings without underscores or
all-caps.

**Exception:** Detailed-design component folders use PascalCase without hyphens (`WebGui`,
`DataProcessor`, `ViPyGrammy`). These match the software component names exactly, so the folder
name doubles as an unambiguous identifier.

### Engineering Notebook Folders Start with the Jira Ticket

```text
14-Engineering-Notebooks/
    PJBIO-1060-Crosssections-over-sticks/
    PJBIO-1210-integrating-into-ecosystem-of-medicbite/
```

**Why:** Each engineering notebook is created in response to a specific ticket. Starting with the
ticket ID makes the folder self-describing and makes it trivially easy to find the documentation
for a given ticket both from the filesystem and from a Jira link.

### Meeting-Minutes Folders Follow a Date Hierarchy

```text
15-Meeting-Minutes/
    2026-06-Jun/        ← year-month-abbreviation
        2026CW23/       ← ISO calendar week
            index.md
```

**Why:** Chronological nesting keeps the archive navigable over years. The month folder groups
weeks for a quick "what happened in April" lookup; the CW folder identifies the exact week for
cross-referencing meeting labels.

---

## Asset Sub-Folders

All non-text assets live in dedicated sub-folders next to `index.md`, named with a leading
underscore:

| Folder | Contents |
| --- | --- |
| `_figures/` | Images (`.png`, `.jpg`, `.svg`), DrawIO files (`.drawio`, `.drawio.svg`), PlantUML files (`.puml`) |
| `_attachments/` | Downloadable files: PDFs, presentations, archives |
| `_listings/` | Code or text files included verbatim via `literalinclude` |
| `_tables/` | CSV or other structured data used by table directives |

**Why the leading underscore:** Sphinx/MyST ignores folders that start with `_` when scanning for
documentation source files. This prevents images and PDFs from being mistakenly treated as pages,
keeps build warnings clean, and signals to any reader of the filesystem that these are supporting
assets, not content pages.

**Co-location principle:** Place assets in `_figures/` alongside the `.md` file that uses them,
not in a central repository-level folder. Co-location means a section and its figures move
together when the folder structure changes, and deleting a section automatically removes its
figures.

**Alternative for `_attachments/`:** If a page links to a file that is also referenced from other
pages, place it at a higher folder level rather than duplicating it.

---

## Figure File Names

Figure files use **lowercase words joined by underscores**, with no hyphens:

```text
project_timeline.png
bd_biomech_decomposition_level_1.drawio
grammy_big_picture.drawio
sd_get_time_series.uml
```

**Why underscores, not hyphens:** Section labels reference figure names as part of their
identifier (`fig_project_timeline`). Underscores are valid Python identifiers and compose
naturally with the label prefix. Hyphens are not valid in label names, which would force a
mismatch between the file name and its label.

**Why lowercase:** Case-sensitive filesystems (Linux build servers) treat `Project_Timeline.png`
and `project_timeline.png` as different files. All-lowercase avoids broken image references when
the docs are built on a system other than the author's Windows machine.

### Diagram Type Prefixes

DrawIO and similar diagram files often carry a short type prefix:

| Prefix | Meaning | Example |
| --- | --- | --- |
| `bd_` | Block diagram | `bd_biomech_decomposition_level_1.drawio` |
| `cd_` | Component diagram | `cd_if_viatar.drawio` |
| `if_` | Interface diagram | `if_viatar.drawio` |
| `sd_` | Sequence diagram | `sd_get_time_series.uml` |

**Why:** A `_figures/` folder can grow large. The prefix groups related files together in
alphabetical listings and makes the purpose of a file clear before it is opened.

**Note:** The prefix is optional for single-topic pages where the folder already provides enough
context.

---

## Two Draw.io Formats for Two Directives

Draw.io diagrams exist in two forms depending on how they are embedded:

| File format | Directive | When to use |
| --- | --- | --- |
| `.drawio.svg` | `{figure}` | Static diagram; no interactive links needed |
| `.drawio` | `{drawio-figure}` | Diagram with clickable navigation links embedded |

**Why:** The `{drawio-figure}` directive embeds the SVG inline in the HTML output, which preserves
hyperlinks drawn inside the diagram. The standard `{figure}` directive references an already-
exported SVG as an image — simpler but without interactivity.

**Advantage:** The distinction is explicit in the file name: `.drawio.svg` signals "exported,
static"; `.drawio` signals "source, live-rendered".

---

## Section Labels

### Underscores, Not Hyphens

Labels always use underscores:

```markdown
(sec_introduction_and_goals)=    ✓
(sec-introduction-and-goals)=    ✗
```

**Why:** Sphinx resolves labels as Python identifiers internally. Underscores are unambiguous
identifiers, while hyphens are parsed as a minus operator in some contexts. Underscores also
visually separate labels from hyphenated prose words, making them easier to spot when scanning a
file.

**Note:** Hyphens are valid MyST syntax and appear in older files in this repository. Both work —
but within a single document, pick one and be consistent.

### Standard Label Prefixes

Every label begins with a short prefix that identifies what kind of element it targets:

```{list-table}
:header-rows: 1

* - Prefix
  - Used for
  - Example
* - `sec_`
  - Headings and sections
  - `(sec_introduction_and_goals)=`
* - `fig_`
  - Figures and diagrams
  - `(fig_grammy_big_picture)=`
* - `tab_`
  - Tables
  - `(tab_release_plan_2026)=`
* - `lst_`
  - Code/text listings
  - `(lst_landmark_identifiers_as_list)=`
* - `def_`
  - Inline definitions
  - `(def_mvp)=`
* - `feature_`
  - Product features
  - `(feature_scan)=`
* - `enabler_`
  - Architectural enablers
  - `(enabler_datamodel_viatars)=`
* - `appendix_`
  - Appendix pages
  - `(appendix_product_maturity_stages)=`
* - `pam_`
  - Process Assessment Model items
  - `(pam_sys_3_architectural_design)=`
* - `svc_`
  - Service pages
  - `(svc_product_data_management)=`
```

**Why:** Without a prefix, a label like `(lifecycle_concepts)=` gives no hint whether it targets
a section, a figure, or a table. Prefixes let a reader understand a `{ref}` call without looking
up where the label is defined.

**Advantage:** Name collisions become unlikely — a section and a figure about the same topic can
coexist as `sec_lifecycle_overview` and `fig_lifecycle_overview`.

### All Lowercase, English Words

Labels translate the heading into English, lower-cased, with underscores for spaces:

| Heading (German) | Label |
| --- | --- |
| `# Qualitätsziele` | `sec_quality_goals` |
| `# Lösungsstrategie` | `sec_solution_strategy` |
| `## Viatar «interface»` | `sec_dd_if_viatar` |

**Why English:** Labels are permanent identifiers. German headings change as content is updated;
an English label derived from the meaning stays stable even if the German wording is refined.
Cross-references scattered across the project do not need updating every time a heading is
reworded.

### Meeting-Minute Labels Encode the Calendar Week

```markdown
(sec_2026CW23)=
# 2026 CW23
```

Sub-sections within a meeting minute use:

```markdown
(sec_2026CW23_1_MON_architecture_review)=
## Monday — Architecture Review
```

Pattern: `sec_YYYYCWNN_D_DAY_topic`

**Why:** Meeting minutes are referenced from sprint notes, engineering notebooks, and decision
records. A label derived from the date is stable (the meeting will always have happened on that
week) and self-describing when it appears in a cross-reference.

---

## Toctree Paths

Toctree entries omit the file extension and use paths relative to the current `index.md`:

````markdown
```{toctree}
:maxdepth: 2

01-Introduction/index
02-Setup/index
03-Reference/index
```
````

**Why no extension:** Sphinx resolves `.md` and `.rst` automatically. Omitting the extension
means the toctree entry does not need updating if a page is converted from RST to Markdown (or
vice versa).

**Why relative paths:** Absolute paths would break if the folder is ever moved or if the docs are
built from a different root. Relative paths are self-contained.

**Alternative:** When linking to a page in another section from a toctree (rare), use the path
relative to the project root with a leading slash: `/12-Glossary/index`.

---

## `{list-table}` Instead of GFM Pipe Tables

All tables use the MyST `{list-table}` directive. GFM pipe syntax (`| col | col |`) is not used
for new content.

````markdown
```{list-table}
:header-rows: 1

* - Version
  - Change
  - Reviewer
* - 1.0
  - Initial release
  - J. Smith
```
````

**Why:** GFM pipe tables break when cell content is long, contains inline markup, or spans
multiple lines. MyST `{list-table}` treats each cell as full Markdown, supports arbitrary content,
and renders consistently in HTML and PDF output.

**Advantage:** No more manual column-width alignment in the source. Cells can contain bullet
lists, code spans, or `{ref}` roles without escaping.

**Alternative:** GFM pipe tables are fine for very simple lookup tables (two or three short
columns, plain text cells) where the visual alignment in the source is a readability win.

---

## `*` as the Bullet Marker for Unordered Lists

Unordered list items use `*` (asterisk), not `-` (hyphen).

```markdown
* System Engineering
* Software Engineering
* Hardware Engineering
```

**Why:** `-` is also used in YAML, `{list-table}` row markers, and task-list syntax. Using `*`
for plain bullets makes the difference visible at a glance and avoids accidental misparse.

**Advantage:** In a file that contains both `{list-table}` directives and regular bullet lists,
`*` bullets are immediately distinguishable from list-table row and cell markers.

**Alternative:** `-` is equally valid CommonMark. If a file already uses `-` consistently
throughout, changing it just for convention's sake adds noise to the diff.

---

## Bilingual Headings with `/` Separator

Pages targeting both English and German readers use a slash separator in headings to show both
language versions on a single line.

```markdown
# Product Maturity Stages / Produktreifegrade

## Purpose / Zweck
```

**Why:** The handbook audience spans German-speaking engineers and English-speaking stakeholders.
A single heading appears in the navigation tree, the page title, and search results — duplicating
the page for each language would fragment cross-references and double the maintenance effort.

**Advantage:** Readers of either language recognise the heading immediately. The English term
comes first and doubles as the canonical identifier for cross-references.

---

## `orphan: true` for Pages Outside the Toctree

Any page that is not yet wired into a `{toctree}` should carry `orphan: true` in its frontmatter.

```yaml
---
orphan: true
---
```

**Why:** Sphinx emits a warning for every `.md` file it finds that is not reachable from any
toctree. Without `orphan: true`, a page under active drafting pollutes the build log and may be
flagged as a CI failure.

**Advantage:** The build stays clean while the page is being written. The `orphan: true` flag also
signals to other authors that the page is a draft not yet integrated into the structure.

---

## `{todo}` for Missing Content, Comments for Disabled Content

Two mechanisms exist for content that is not yet rendered — they serve different purposes.

**`{todo}` — content that needs to be written:**

````markdown
```{todo}
Describe the release branching strategy.
```
````

Renders as a visible call-out in draft builds. Searchable. Can carry a title.

**HTML comment — content that is drafted but temporarily hidden:**

```html
<!--
## Aufbau

This section will cover the structural overview once the diagram is finalised.
-->
```

Invisible in all output. Preserves intent for the next author.

**Why the split:** `{todo}` communicates a gap to reviewers and readers of the draft. An HTML
comment is appropriate when the content exists in some form but should not appear in any build
yet (e.g. a section disabled pending approval).

**Advantage:** Build tooling can count open `{todo}` items as a quality metric. HTML comments
accumulate silently and should be reviewed and either promoted or deleted when the surrounding
content matures.

---

## User Abbreviations

Team members are referenced with `{user}` using short uppercase codes, typically three or four
letters derived from their name:

```markdown
Written by {user}`AMAN`, {user}`FKR`, and {user}`MM`.
```

Real codes used in this project: `AMAN`, `FKR`, `MM`, `KOO`, `TMOH`, `LPO`, `DWI`, `TCH`,
`JHH`.

**Why short codes:** Full names change (spelling preferences, marriage, transliteration) and are
verbose in lists of attendees. Short codes are stable identifiers; the `{user}` role expands them
to a rendered display name and optional link.

**Convention for new codes:** Use the first letter of first name plus the first two letters of
the last name, capitalized (e.g. Alexander Mann-Wahrenberg → `AMAN`). If that collides, extend
to four characters.

---

## Jira Ticket References

Reference Jira tickets inline with the `{jira}` role, never as a plain URL:

```markdown
See {jira}`PJBIO-1060` for the full specification.   ✓
See https://jira.vitronic.de/browse/PJBIO-1060        ✗
```

**Why the role:** The `{jira}` role produces a consistent link regardless of the Jira server URL.
If the Jira instance is migrated, only the role's base URL configuration needs updating, not every
individual reference in the documentation.

**Project codes:** Use `PJBIO-` for the primary Biomech project. Other project codes (e.g. `CPQ-`)
appear only when cross-referencing a dependency ticket in another project.

---

## Language

Body text and headings are written in **German**. Technical identifiers — class names, method
signatures, API paths, file names, configuration keys — stay in **English** regardless of
surrounding language:

```markdown
Die Klasse `PluginFactory` stellt die Methode `createPlugin(type)` bereit.
Der Endpunkt `/api/v2/viatars/{viatar_id}/crosssections` gibt ...
```

**Why German for prose:** The primary readership is the development team and stakeholders, who
communicate in German. German prose avoids the awkward half-translated style that results from
forcing technical documentation into a non-native language.

**Why English for identifiers:** Source code, API contracts, and configuration files are in
English. Copying an identifier verbatim from the code into the documentation and back into the
code must be lossless. Translating identifiers would create a gap between the documentation and
the system it describes.

**Section labels and file names are always English** — see the respective sections above.
