# v1.0.0 (2026-05-02)

## What's Changed

### Features
- Initial stable release with full introspection API
- **Introspect** module with four sub-modules:
  - `Discover` - Module, program, function, and constant discovery
  - `Describe` - Detailed symbol description (type, signature, etc.)
  - `Search` - Pattern-based search across all symbols  
  - `Json` - JSON output formatters for LLM consumption

### Installation
- PMP installable: `pmp install TheSmuks/pike-introspect`
- Agent skill: `npx skills add TheSmuks/pike-introspect`

### Technical
- Works with Pike 8.0+
- No runtime dependencies
- Comprehensive test suite

**Full Changelog**: https://github.com/TheSmuks/pike-introspect/compare/...main
