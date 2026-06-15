(sec_solution_strategy)=

# Solution Strategy

The following fundamental decisions shape HermesBaby's architecture. Each decision is motivated by one or more of the quality goals defined in {ref}`sec_quality_goals`.

(sec_key_decisions)=

## Key Decisions

Docs-as-Code
: Documentation source files live in a Git repository alongside the system's source code. This gives documentation the same review, branching, merging, CI, and baseline workflows that software development teams already use. Changes to documentation go through pull requests and are traceable to authors and timestamps. Addresses: **Auditability**, **Reproducibility**.

CLI-first workflow
: All HermesBaby operations are exposed exclusively through the `hb` command-line interface. There is no required GUI component. This makes every documentation operation scriptable, automatable in CI pipelines, and executable in headless environments without a display. Addresses: **Corporate Integrability**, **Portability**.

Sphinx + MyST Markdown as rendering engine
: Sphinx is the industry-standard documentation engine for the Python ecosystem, with a mature extension architecture, strong cross-referencing, and multiple output formats. MyST-Parser extends Sphinx to accept Markdown source files, lowering the authoring barrier compared to reStructuredText without sacrificing Sphinx's directive and reference system. Addresses: **Engineer Usability**, **Maintainability**.

Kconfig for project configuration
: The `.hermesbaby` project configuration file uses Linux-kernel-style Kconfig syntax. This provides a typed, self-documenting, and toolchain-validated configuration system. The configuration is a versionable plain-text file — explicit, diffable, and completely reproducible from source. Addresses: **Reproducibility**, **Auditability**.

Template-driven project creation
: Documentation projects are scaffolded from validated cookiecutter templates. Teams start from a consistent, immediately buildable structure (e.g. the arc42 template) rather than assembling one from scratch. Templates encapsulate best practices for structure, configuration, and required Sphinx extensions. Addresses: **Engineer Usability**, **Corporate Integrability**.

Python as the implementation language
: Python is cross-platform, available in most engineering environments, and pip-installable with no system-level package manager required. The entire Sphinx/MyST ecosystem is Python-native, and tooling for CLI (Typer), configuration (kconfiglib), and templating (cookiecutter) are all mature Python libraries. Addresses: **Portability**, **Maintainability**.

SSH-based controlled publishing
: Publishing documentation requires explicit SSH credentials and a fully configured target in `.hermesbaby`. There is no automatic or implicit "push to the internet" behaviour. This prevents accidental publication to wrong targets and supports the distribution policies of corporate and regulated environments. Addresses: **Auditability**, **Corporate Integrability**.

(sec_strategy_quality_mapping)=

## Mapping to Quality Goals

```{list-table}
:header-rows: 1
* - Quality Goal
  - Addressed by
* - Reproducibility
  - Kconfig configuration (deterministic input), Git-tracked source (fixed revision), Sphinx's deterministic build pipeline
* - Auditability
  - Docs-as-Code (Git history, pull-request reviews, signed tags), Kconfig configuration (explicit, versionable), SSH publishing (explicit credentials and targets)
* - Engineer Usability
  - CLI simplicity (`hb html`, `hb publish`), MyST Markdown (familiar syntax), template-driven project creation (ready-to-build starting point), live-preview server
* - Corporate Integrability
  - CLI-first workflow (CI-scriptable), headless execution (no GUI), SSH publishing (access-controlled), access-control artefact generation
* - Portability
  - Python cross-platform runtime, CLI-first (no OS-native GUI), tested on Windows and Linux
* - Maintainability
  - Modular Python package (independent CLI, template, build, publish subsystems), Sphinx extension ecosystem (extend without forking core), Kconfig isolates configuration from code
```
