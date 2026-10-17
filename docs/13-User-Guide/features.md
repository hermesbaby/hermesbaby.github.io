(sec_hermesbaby_usage)=
# Using Hermesbaby

Hermesbaby builds and previews a documentation project from its source files. This page walks
through the everyday workflow first, then describes options you can use as your project grows.

## 1. Install Hermesbaby

Install Hermesbaby in your Python environment. For example, with `uv`:

```bash
uv tool install hermesbaby
```

The `hb` command is then available from your terminal.

## 2. Create or configure your project

For a new documentation project, start project creation with:

```bash
hb new
```

For an existing project, work from its root directory and configure its Hermesbaby settings with:

```console
hb configure
```

Hermesbaby uses the `.hermesbaby` file to determine project settings, including the documentation
source, configuration, and build directories. Keep this file with the project so builds use the
same settings.

## 3. Build and preview

Build the HTML documentation with:

```bash
hb html
```

To see changes while you write, start the live HTML preview:

```bash
hb html --live
```

Use `hb clean` to remove generated build output. For the basic authoring syntax, see
[MyST Markdown Basics](basics.md); for the complete syntax, see the [MyST reference](language.md).

## 4. Build part of a project

Use `--partly` to build a section while you work on it. A directory uses its `index.md` or
`index.rst` entry point. You can also pass a Markdown or reStructuredText file directly:

```console
hb html --partly docs/architecture
hb html --partly docs/architecture/system-overview.md
```

The path can be relative or absolute. When you pass a file, its containing directory is used as
the source directory.

## Configure project features

The following settings are optional and can be applied after the basic build workflow is working.

### Copyright year

Hermesbaby generates the copyright notice from `CONFIG_DOC__AUTHOR` and `CONFIG_DOC__YEAR` in
`.hermesbaby`. A year earlier than the current build year is shown as a range; the current or a
future year is shown by itself. Set the year to `0` to omit it:

```ini
CONFIG_DOC__YEAR=1976
```

For example, `1976` is shown as a range ending in the build year. Setting
`CONFIG_DOC__YEAR=0` produces the author name without a year.

### Optional Sphinx Needs extension

Hermesbaby does not install or enable `sphinx-needs` by default. If your project uses its
requirements directives, add the extension to your project's requirements and enable it in the
Sphinx configuration directory (usually `docs`):

```text
# docs/requirements.txt
sphinx-needs
```

```python
# docs/conf.py
extensions.append("sphinx_needs")
```

Hermesbaby installs the requirements listed in that directory when needed and applies its
`sphinx-needs` settings when the extension is enabled.

## Further reading

Continue to the [MyST Markdown reference](language.md) for syntax details, or read the
[authoring conventions](conventions.md) for this documentation project's organizational guidelines.
