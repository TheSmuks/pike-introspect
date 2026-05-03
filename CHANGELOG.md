# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [Unreleased]

### Added

- Template adoption: adopt ai-project-template v0.6.0 with project infrastructure,
  CI quality gates, OMP agent framework, dev container, and reference documentation


## [0.2.0] - 2026-05-03

### Added

- Source location extraction in `describe_program()`, `describe_function()`, and
  `describe_object()` with `source_file` and optional `source_line` fields (#1)
- Inheritance chain traversal in `describe_program()` with `inherits`,
  `inherited_methods`, and `inherited_constants` fields (#2)
- New `resolve_symbol()` function in Discover.pmod for cross-file identifier
  resolution with type and location info (#3)
- Methods and constants in `describe_program()` now return as array of mappings
  with `name` and location info


## [0.1.0] - 2026-05-01

### Added

- Initial release
- `Introspect` module with the following sub-modules:
  - `Discover` - Module, program, function, and constant discovery
  - `Describe` - Detailed symbol description (type, signature, etc.)
  - `Search` - Pattern-based search across all symbols
  - `Json` - JSON output formatters for LLM consumption
- Installation via PMP: `pmp install TheSmuks/pike-introspect`
- Agent skill: `pike-introspection` for use with `npx skills add`
- Reference documentation for introspection API and runtime discovery
- Test suite using PUnit