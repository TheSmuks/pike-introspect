# 0001: Adopt ai-project-template v0.6.0

**Status**: Accepted
**Date**: 2026-05-03
**Decision Maker**: TheSmuks

## Context

The `pike-introspect` repository was created as a standalone Pike module. As the project matures, there is value in aligning with a shared project template to benefit from consistent CI quality gates, contribution guidelines, agent configurations, and OMP extensions infrastructure.

`TheSmuks/ai-project-template` v0.6.0 is a well-defined project scaffold with:
- CI quality gates (commit lint, changelog enforcement, blob size policy)
- Agent configuration files (`.omp/agents/`, `.omp/rules/`, `.omp/hooks/`)
- Documentation infrastructure (CONTRIBUTING.md, UPGRADING.md, docs/)
- Dev container configuration

The project is existing, has real content, and follows the ADOPTING.md incremental adoption path.

## Decision

Adopt `ai-project-template` v0.6.0 into `pike-introspect`, following the ADOPTING.md incremental adoption path for existing repos.

**MUST** preserve all existing project-specific files that already contain real content:
- `AGENTS.md` — already filled with Pike project context
- `ARCHITECTURE.md` — already filled with system design
- `CHANGELOG.md` — already has real project history starting at v0.1.0
- `README.md` — already describes the Pike Introspect project
- `.github/workflows/ci.yml` — existing Pike-specific CI (PMP + test runner)

**MUST** skip template files that are process docs for first-time setup:
- `SETUP_GUIDE.md` — greenfield-only, not applicable to existing repo
- `ADOPTING.md` — process doc for first-time adoption, not ongoing project file

**SHOULD** adapt all copied files with Pike-specific values where they contain placeholders or language-specific conventions.

**SHOULD** include the `.omp/` agent framework infrastructure as-is (agents, commands, rules, hooks, skills, tools).

## Consequences

### Positive

- Consistent CI quality gates across all PRs (commit-lint, changelog-check, blob-size-policy)
- Automatic branch cleanup after PR merge
- OMP agent configurations for code review, ADR writing, changelog updates
- Convention enforcement rules (conventional commits, no placeholders, changelog required)
- Dev container for consistent development environment
- Reference documentation (ci.md, agent-files-guide.md, omp-extensions-guide.md)
- ADR process infrastructure for documenting future decisions

### Negative

- Additional CI workflows to maintain (4 new workflows alongside existing ci.yml)
- Template version tracking obligation (`.template-version`)
- Upgrade path to manage on future template releases

### Neutral

- Audit script added for template compliance checking
- Skills infrastructure added (cut-release, merge-to-main, template-guide, setup)
- Tools infrastructure added (template-audit)
- Hooks added (protect-main, template-compliance-hint)

## Alternatives Considered

### Alternative 1: Full Template Adoption

Copy everything verbatim from the template and overwrite all files, then restore project-specific content from git history.

**Rejected because**: Wasted effort — we know our project-specific files are correct and contain real content. The ADOPTING.md incremental path is specifically designed for this situation.

### Alternative 2: No Template Adoption

Continue without template infrastructure and maintain conventions manually.

**Rejected because**: Loses the benefits of consistent CI quality gates, agent configurations, and documentation infrastructure. The project benefits from these conventions without the setup cost.

### Alternative 3: Selective Tooling Only

Copy only CI workflows and skip OMP extensions, skills, and docs.

**Rejected because**: The OMP infrastructure is the primary value-add for agent-augmented development. CI workflows without agent conventions leave the most valuable part on the table.

## Implementation

Adoption performed in phases per the ADOPTING.md incremental path:

| Phase | Files | Strategy |
|-------|-------|----------|
| 1. Project Infrastructure | LICENSE, .editorconfig, .gitattributes, .gitignore, .architecture.yml, .template-version | Adapted for Pike |
| 2. GitHub Configuration | CODEOWNERS, SECURITY.md, PR template, release-draft, dependabot.yml, issue templates | Adapted where needed |
| 3. CI Workflows | commit-lint.yml, changelog-check.yml, blob-size-policy.yml, branch-cleanup.yml | Verbatim (additive) |
| 4. Documentation | CONTRIBUTING.md, UPGRADING.md, docs/ | Adapted for Pike |
| 5. OMP Agent Framework | .omp/agents/, .omp/commands/, .omp/rules/, .omp/hooks/, .omp/skills/, .omp/tools/, .omp/settings.json | Verbatim |
| 6. Dev Container | .devcontainer/devcontainer.json | Adapted for Pike/PMP |
| 7. ADR | docs/decisions/0001-adopt-template.md | Written (this document) |
