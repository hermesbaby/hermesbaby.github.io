(sec_introduction_and_goals)=

# Introduction and Goals

(sec_problem_formulation)=

## Requirements Overview

In complex engineering environments, documentation is not an afterthought — it is an engineering discipline of its own {cite:p}`DocsAsCode2025`. Specifications, interfaces, workflows, and handbooks must be accurate and versioned, readable and reviewable, traceable and testable. Yet two common failure modes undermine this in practice.

First, documentation produced in conventional office tools (word processors, shared drives, wikis) is disconnected from version control, resistant to automated validation, and hard to baseline with precision. In regulated domains — machinery, medical devices, automotive electronics, industrial automation — this is a compliance risk: standards such as IEC 62304, Automotive SPICE, and ISO/IEC/IEEE 15288 require controlled, reviewable, traceable, and baselined technical documentation as part of the engineering evidence record.

Second, heavyweight modeling tools (Enterprise Architect, IBM Rational Rhapsody, DOORS) promise integrated traceability but often fail to establish a shared, precise, and verifiable understanding of a system {cite:p}`SpecCenteredEngineering2026`. Proprietary formats trap information, reviewing changes requires a tool licence, and exported diagrams routinely substitute for actual written specifications. The tool's structural coherence is mistaken for semantic correctness.

HermesBaby makes the Docs-as-Code approach turnkey for software and systems engineers, avoiding both failure modes. It provides a CLI-first environment built on Sphinx and MyST Markdown, integrated with Git-based workflows and CI/CD pipelines. Its essential functions are:

1. **Template-based project creation** — `hb new --template <name>` scaffolds a documentation project from a proven template (arc42, user guide, etc.) without configuring a toolchain from scratch.
2. **Deterministic, CLI-driven builds** — `hb html` invokes a reproducible Sphinx-based build that produces identical output from identical source and configuration.
3. **Live preview** — `hb html --live` starts a local preview server (default port 1976) that reflects edits in real time, supporting efficient authoring cycles.
4. **Toolchain validation** — `hb tools check` verifies the availability and version compatibility of all required external tools before a build.
5. **Controlled publishing** — `hb publish` transfers built documentation to a target server via SSH and applies access-control artefacts, supporting distribution policies in corporate and regulated environments.
6. **Kconfig-based project configuration** — A single `.hermesbaby` file drives all document metadata, build paths, publishing targets, and styling, making configuration explicit, versionable, and reproducible.

(sec_quality_goals)=

## Quality Goals

The following quality goals are the most important drivers for HermesBaby's architecture. They are mapped to the ISO/IEC 25010 quality model {cite:p}`ISO_25010`.

```{uml} _figures/quality_goals.puml
:caption: ISO/IEC 25010 quality characteristics. Blue-highlighted characteristics are HermesBaby's quality goals.
```

Reproducibility
: The same source and configuration must always produce the same documentation output. Non-reproducible builds undermine auditability and make compliance evidence unreliable. Maps to **Reliability**.

Auditability
: Every change to documentation must be traceable to an author, a time, and a reason. Publishing, access control, and configuration must be inspectable. The written specification — not a diagram or a tool model — is the authoritative source of truth {cite:p}`SpecCenteredEngineering2026`. Regulated engineering requires full, licence-free audit trails. Maps to **Security** and **Maintainability**.

Engineer Usability
: Engineers should author, build, and publish documentation without becoming documentation-tooling experts. Staying in a familiar toolchain — text editor, Git, CI — lowers the contribution barrier and increases documentation accuracy {cite:p}`DocsAsCode2025`. High setup friction leads to documentation rot. Maps to **Interaction Capability**.

Corporate Integrability
: HermesBaby must integrate into existing CI/CD pipelines, corporate documentation portals, access-control mechanisms, and restricted or air-gapped network environments. Maps to **Compatibility**.

Portability
: HermesBaby must operate consistently across Windows, Linux, local workstations, devcontainers, and CI runners. Engineering teams work in heterogeneous environments. Maps to **Flexibility**.

Maintainability
: The CLI, templates, Sphinx extensions, and publishing logic must remain modular and independently evolvable. Tight coupling to specific Sphinx extension versions creates toolchain-drift risk.

(sec_stakeholders)=

## Stakeholders

```{list-table}
:header-rows: 1
* - Role
  - Expectations
* - Software / Systems Engineer
  - Can create, build, preview, and publish technical documentation using a simple CLI without deep documentation-tooling expertise. Templates lower the entry barrier; live preview speeds up review cycles.
* - Engineering Manager / Tech Lead
  - Documentation follows the team's established structure and style. Changes go through pull-request review. Baselines can be tagged and published on demand via CI.
* - Quality / Compliance Engineer
  - Evidence artefacts (architecture docs, ADRs, traceability matrices) are version-controlled, reviewable, and publishable in a form that satisfies standards such as IEC 62304, Automotive SPICE, and ISO/IEC/IEEE 42010.
* - Corporate IT / Infrastructure
  - HermesBaby runs headlessly in CI, integrates with SSH-based publishing targets and access-control mechanisms, and works inside restricted or air-gapped networks.
* - Documentation Reader
  - Published documentation is navigable, searchable, and rendered correctly. Cross-references and diagrams are intact.
* - External Auditor / Assessor
  - Published documentation packages contain a visible build baseline (commit hash, build date, release tag). Architecture decisions, risk items, and quality goals are documented and cross-referenced.
* - HermesBaby Developer / Contributor
  - The CLI, template system, Sphinx extensions, and publishing subsystem are modular. New templates and extensions can be added without breaking existing projects. The test suite covers core workflows end-to-end.
```
