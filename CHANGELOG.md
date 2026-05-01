# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
