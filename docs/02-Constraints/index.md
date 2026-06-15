(sec_constraints)=

# Constraints

Constraints limit the solution space for HermesBaby's architecture and implementation. They are not open for negotiation within the project.

(sec_technical_constraints)=

## Technical Constraints

```{list-table}
:header-rows: 1
* - Constraint
  - Background
* - Python 3 runtime required on every host that runs HermesBaby
  - HermesBaby is distributed as a Python package. A compatible Python 3 interpreter must be available on the workstation, devcontainer, or CI runner. The exact minimum version is declared in `pyproject.toml`.
* - Sphinx and MyST-Parser are the document rendering engine
  - HermesBaby delegates all source-to-HTML/PDF conversion to Sphinx. MyST-Parser extends Sphinx to accept MyST Markdown source files. Both are mandatory runtime dependencies with their own release cycles, which can introduce breaking changes.
* - PlantUML requires a Java Runtime Environment on the build host
  - Sequence diagrams and other UML diagrams are authored as `.puml` files and rendered by PlantUML. PlantUML is a Java application; a JRE must be present. This adds a non-Python dependency to every build host.
* - draw.io CLI required for block diagram rendering
  - Block diagrams are authored as `.drawio` files. Rendering them during the documentation build requires the draw.io desktop application or its headless CLI equivalent to be installed separately from Python dependencies.
* - Git executable required on build hosts that inject metadata
  - HermesBaby injects build-time metadata (commit hash, branch name, tags) from the local Git repository into the generated documentation. The `git` executable must be available and the working directory must be inside a Git repository.
* - SSH client and configured key required for `hb publish`
  - Publishing transfers artefacts to a remote host via SCP/SSH. A compatible SSH client and a private key file must be present and configured in `.hermesbaby` before publishing can succeed.
* - Windows 10+ and Linux (Debian/Ubuntu) are the supported operating systems
  - HermesBaby is tested on these two platforms. macOS may work but is not an officially supported target. CI runners are assumed to be Linux-based.
* - Build must succeed without internet access after initial dependency installation
  - Engineering organisations often run CI in restricted or air-gapped networks. After `pip install hermesbaby` and its dependencies, all build operations must complete offline.
```

(sec_organisational_constraints)=

## Organisational Constraints

```{list-table}
:header-rows: 1
* - Constraint
  - Background
* - Distributed as a pip-installable PyPI package
  - Installation must work with `pip install hermesbaby` and no additional package managers. This is the only distribution channel for end users.
* - Open source; all dependencies must have compatible licences
  - HermesBaby is published under an open-source licence. Every dependency must carry a licence that is compatible with this. Proprietary or copyleft-only dependencies are not permitted.
* - Source code and issue tracking hosted on GitHub
  - Repository, issue tracking, pull requests, and CI/CD pipelines all run on GitHub. Contributions follow the standard GitHub pull-request workflow.
* - No breaking changes to the CLI or `.hermesbaby` format without a MAJOR version bump
  - Engineering teams embed `hb` commands in CI scripts and commit `.hermesbaby` files to repositories. Breaking these without a clear version signal would silently break downstream projects.
```

(sec_conventions)=

## Conventions

```{list-table}
:header-rows: 1
* - Convention
  - Background
* - `.hermesbaby` uses Kconfig syntax for project configuration
  - All project metadata, build paths, publishing targets, and styling settings live in a single `.hermesbaby` file using Linux-kernel-style Kconfig syntax. Alternative configuration formats are not supported.
* - Documentation source files are authored in MyST Markdown
  - All user-facing documentation content is written in `.md` files using MyST Markdown directives. Pure reStructuredText (`.rst`) source files are not a supported authoring target.
* - Block diagrams are DrawIO files; sequence diagrams are PlantUML files
  - `.drawio` files are used for context, container, and component diagrams. `.puml` files are used for sequence, dynamic, and UML diagrams. This split follows the CLAUDE.md authoring conventions for this document.
* - Semantic versioning (MAJOR.MINOR.PATCH)
  - HermesBaby releases follow semantic versioning. A MAJOR bump signals breaking changes in the CLI interface or `.hermesbaby` configuration format.
```
