(sec_toctree_modes)=
# Toctree Modes: Directive vs. Filesystem

Sphinx needs a **toctree** — a tree of documents — to know which pages exist and in what order
to render them. hermesbaby offers two ways to define it, selectable per project via `hb
configure`:

```{list-table}
:header-rows: 1

* - Config value
  - Meaning
* - `CONFIG_DOC__TOCTREE_MODE_DIRECTIVE` (default)
  - You write explicit ` ```{toctree}``` ` directives (see
    {ref}`sec_authoring_guide`).
* - `CONFIG_DOC__TOCTREE_MODE_FILESYSTEM`
  - hermesbaby derives the toctree automatically from the folder/file layout under `docs/`.
```

This page explains the filesystem mode: how it works, how to customize it with frontmatter, and
when to prefer it over the directive.

---

## Enabling Filesystem Mode

The mode is a Kconfig choice named **"Toctree Definition"**, set via `hb configure` or directly
in the project's `.hermesbaby` file:

```text
CONFIG_DOC__TOCTREE_MODE="filesystem"
# CONFIG_DOC__TOCTREE_MODE_DIRECTIVE is not set
CONFIG_DOC__TOCTREE_MODE_FILESYSTEM=y
```

**Why a project-wide switch, not a per-page choice:** Mixing the two within one project is not
supported. If a document still contains an explicit ` ```{toctree}``` ` directive while filesystem
mode is active, the build fails with `toctree directive not expected with external-toc`. Pick one
mode per project.

---

## How Filesystem Mode Works

With filesystem mode enabled, hermesbaby scans the `docs/` folder before every build and derives
the navigation tree from the files and folders it finds — no `{toctree}` directive needed
anywhere. Under the hood it uses
[sphinx-external-toc](https://github.com/executablebooks/sphinx-external-toc), a Sphinx extension
that reads the tree from a generated `_toc.yml` file instead of in-document directives.

### Folder → Toctree Mapping

* Every folder's `index.md` becomes that folder's own toctree node; its siblings files and
  subfolders become its children.
* Within one folder, **all direct files come before all subfolders**, regardless of numeric
  prefixes.
* Both files and subfolders are ordered by **natural sort** (numeric-aware): `2-second.md` sorts
  before `10-tenth.md`, and `01-first.md` sorts as `1`, not lexically.
* Traversal is depth-first: a folder's own children are fully listed before its next sibling
  folder is visited.

```{list-table}
:header-rows: 1

* - Filesystem
  - Rendered order
* - `index.md`
    `b-top-file.md`
    `01-first-folder/index.md`
    `01-first-folder/child.md`
    `02-second-folder/index.md`
  - `index`
    `b-top-file`
    `01-first-folder/index`
    `01-first-folder/child`
    `02-second-folder/index`
```

```{important}
A folder that contains **only subfolders** (no file of its own) is silently dropped from the
generated toctree — together with everything nested below it. This is a limitation of
`sphinx-external-toc`'s filesystem walk, not something hermesbaby can work around. Give the
folder its own `index.md`, or, if that is not possible, mark every page in the orphaned subtree
with `orphan: true` (see {ref}`sec_authoring_conventions`) so the build does not fail with
"document isn't included in any toctree".
```

### Live Rebuilds

`hb html-live` / `hb pdf-live` re-derive the toctree before every incremental rebuild, so files
added, removed, or renamed while the live server is running are picked up immediately, the same
way content edits already are.

---

## Directive Mode vs. Filesystem Mode

```{list-table}
:header-rows: 1

* -
  - Directive (`{toctree}`)
  - Filesystem
* - Navigation order
  - Whatever you type in the directive
  - Derived from file/folder names (numeric prefixes recommended, see
    {ref}`sec_authoring_conventions`)
* - Adding a page
  - Create the file **and** add an entry to a `{toctree}`
  - Create the file — it appears automatically
* - Forgetting a step
  - Page not in any toctree → build warning
  - Not possible for a normal file; only "folder with no file of its own" needs `orphan: true`
* - Reordering pages
  - Reorder lines in the directive
  - Rename files/folders to change their sort position
* - Per-page toctree options (`caption`, `hidden`, `numbered`, …)
  - Directive options, inline
  - Frontmatter `toctree:` block (see below)
* - Cross-project / non-uniform trees
  - Flexible — a toctree can list files from anywhere
  - Bound to the actual `docs/` folder layout
* - Mixing modes
  - N/A
  - Not supported in the same project — a leftover `{toctree}` directive breaks the build
```

**When to prefer filesystem mode:** Projects that already follow the folder conventions in
{ref}`sec_authoring_conventions` (numeric prefixes, one `index.md` per folder) get the toctree for
free — there is no directive to keep in sync as pages are added, moved, or removed.

**When to prefer directive mode:** Projects that need a page to appear in more than one place, or
where reading order deliberately differs from the filesystem layout (e.g. an appendix listed
out of alphabetical order), keep the directive's explicit control.

---

## Customizing with Frontmatter

The filesystem layout alone only determines structure and order — it can't express a custom
title or `sphinx-external-toc` display options. Declare those in a `toctree:` block in the page's
YAML frontmatter instead:

```yaml
---
toctree:
  title: Custom Title
  options:
    caption: Section Caption
    hidden: false
    maxdepth: 2
    numbered: true
    reversed: false
    titlesonly: true
    style: alphaupper
    restart_numbering: true
---
```

```{list-table}
:header-rows: 1

* - Key
  - Type
  - Effect
* - `title`
  - string
  - Overrides the entry's title in the parent's toctree (the page's own `#` heading is unaffected).
* - `options.caption`
  - string
  - Caption shown above this node's child entries.
* - `options.hidden`
  - bool
  - Keeps the child entries out of the rendered page body while still building the navigation.
* - `options.maxdepth`
  - int
  - How many nesting levels of this node's children are shown in the sidebar.
* - `options.numbered`
  - bool or int
  - Numbers this node's child entries; an integer caps the numbering depth.
* - `options.reversed`
  - bool
  - Reverses the order of this node's direct children.
* - `options.titlesonly`
  - bool
  - Shows only page titles in the sidebar, not sub-headings.
* - `options.style`
  - string or list of strings
  - Numbering style, e.g. `alphaupper`, or `[romanupper, alphalower]` for nested levels.
* - `options.restart_numbering`
  - bool
  - Restarts numbering from 1 for this node's children.
```

These keys — and any others `sphinx-external-toc` supports — are documented in full at
<https://github.com/executablebooks/sphinx-external-toc>. hermesbaby merges whatever you put
under `options:` verbatim into the generated `_toc.yml`.

```{note}
A `toctree:` block with no keys, or a file with no frontmatter at all, is perfectly valid — the
page just gets its filesystem-derived position with no customization.
```

### Scope: Any File, Not Just the Root — and Not Recursive

A `toctree:` block is **not** limited to the top-level `index.md`. Put it in **any** `*.md`
file; hermesbaby matches each block to that exact file and merges it into that file's own node
only — nothing is inherited automatically from a parent folder, and nothing propagates down to
child pages:

* **`title`** relabels how *that specific file* is displayed wherever it appears as an entry —
  i.e. in its *parent* folder's child list. It has no visible effect when set on the project
  root, since the root is never itself listed as someone else's child entry.
* **`options.*`** govern how *that file's own children* are rendered — the caption above them,
  whether they're hidden, how deep and how they're numbered, and so on. They therefore only do
  anything on a file that actually has children in the tree: a folder's `index.md` (or
  `overview.md`, or whichever file the folder uses as its own page), or the root. Setting
  `options:` on a leaf page with no children is accepted but has no visible effect, since there
  is no child list for it to apply to.
* Each node's `options:` are independent. If `folder-a/index.md` sets `options.numbered: true`,
  a page in `folder-a/sub/index.md` needs its **own** `toctree:` block to be numbered too —
  hermesbaby does not walk the tree copying a parent's options onto its descendants:

  ```yaml
  # folder-a/index.md
  ---
  toctree:
    options:
      numbered: true
  ---
  ```

  ```yaml
  # folder-a/sub/index.md — needs its own block; nothing is inherited from folder-a/
  ---
  toctree:
    options:
      numbered: true
  ---
  ```

```{note}
`numbered` and `maxdepth` are standard Sphinx toctree-directive options, and Sphinx's own
rendering does let a *nested* toctree inherit its enclosing toctree's `numbered`/`maxdepth`
unless the nested one sets its own value — that behavior comes from Sphinx itself, not from
hermesbaby's frontmatter merge. The merge step described above always stays strictly per-file: it
never reads or copies a value from another file's frontmatter.
```

```{warning}
The keys `root`, `file`, `entries`, and `subtrees` describe tree **structure** and are always
computed from the actual filesystem — they are ignored if present under `toctree:` in
frontmatter. Structure comes from where the file lives, not from what it claims about itself.
```

### Example: A Section with a Hidden, Numbered Sub-Navigation

```yaml
---
toctree:
  title: Appendix
  options:
    caption: Appendix
    numbered: 2
    hidden: false
---
# Appendix
```

Placed in an `index.md`, this renames the section's toctree entry to "Appendix", captions its
children "Appendix", and numbers two levels of nesting beneath it — all without a single
`{toctree}` directive anywhere in the project.
