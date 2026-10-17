(sec_hermesbaby_features)=
# HermesBaby Features

This page describes features that affect how you build and configure a HermesBaby document.

## Partial Builds

Use `--partly` to build a section of your document while you work on it. A directory uses its
`index.md` or `index.rst` entry point. You can also pass a Markdown or reStructuredText file
directly to use that file as the entry point:

```bash
hb html --partly docs/architecture
hb html --partly docs/architecture/system-overview.md
```

The path can be relative or absolute. When you pass a file, its containing directory is used as
the source directory.

## Copyright Year

HermesBaby generates the copyright notice from `CONFIG_DOC__AUTHOR` and `CONFIG_DOC__YEAR` in
your `.hermesbaby` configuration. A year earlier than the current build year is shown as a range;
the current or a future year is shown by itself. Set the year to `0` to omit it:

```ini
CONFIG_DOC__YEAR=1976
```

For example, a value of `1976` is shown as a range ending in the build year. Setting
`CONFIG_DOC__YEAR=0` produces the author name without a year.

## Optional Sphinx Needs Extension

HermesBaby does not install or enable `sphinx-needs` by default. If your project uses its
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

HermesBaby installs the requirements listed in that directory when needed and applies its
`sphinx-needs` settings when the extension is enabled.
