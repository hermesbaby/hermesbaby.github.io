(sec_context_and_scope)=

# Context and Scope

HermesBaby is the system-of-interest. It operates inside an engineering organisation's development environment and interacts with engineers, version-control infrastructure, CI pipelines, rendering tools, and publishing targets.

```{drawio-figure} _figures/context.drawio
HermesBaby in its operational context: engineers, Git, CI, rendering toolchain, documentation portal, and access-control mechanism.
```

(sec_external_actors)=

## External Actors and Systems

```{list-table}
:header-rows: 1
* - Actor / System
  - Interaction with HermesBaby
* - **Software / Systems Engineer**
  - Invokes `hb` CLI commands interactively: `hb new` to create a project, `hb html` to build, `hb html --live` to preview, `hb tools check` to validate the toolchain, and `hb publish` to deploy. The engineer edits documentation source files in a text editor or IDE between commands.
* - **Git Repository**
  - HermesBaby reads documentation source (`.md`, `.puml`, `.drawio`, `.bib`), the `.hermesbaby` project configuration, and template files from the Git-managed working tree. It queries the Git executable for build-time metadata: commit hash, branch name, and tags that are embedded in the published output.
* - **CI Pipeline**
  - An automated pipeline (e.g. GitHub Actions) triggers `hb tools check`, `hb html`, and optionally `hb publish` on every push or pull request. HermesBaby must run headlessly without interactive prompts. The CI runner must have Python, HermesBaby, and all rendering tools installed.
* - **Sphinx / MyST-Parser Toolchain**
  - HermesBaby invokes Sphinx with MyST-Parser and a project-specific set of Sphinx extensions. Sphinx reads the source tree, resolves cross-references and citations, renders diagrams, and writes the output (HTML, optionally PDF) to the configured output directory.
* - **PlantUML**
  - The `sphinxcontrib-plantuml` Sphinx extension invokes the PlantUML Java application to render `.puml` source files (sequence diagrams, dynamic views, UML diagrams) into raster or vector images during the Sphinx build.
* - **draw.io CLI**
  - The `sphinxcontrib-drawio` Sphinx extension invokes the draw.io headless CLI to render `.drawio` source files (context, container, component diagrams) into images during the Sphinx build.
* - **Documentation Portal / Web Server**
  - Receives the static HTML output published by `hb publish`. Serves the documentation to readers. The portal must be reachable from the build host via SSH and must support static file serving.
* - **Access-Control Mechanism**
  - HermesBaby generates access-control artefacts (e.g. `.htaccess` files) derived from the documentation structure and the confidentiality settings in `.hermesbaby`. These artefacts are deployed alongside the HTML output so that the portal's web server can enforce access restrictions on individual sections.
```
