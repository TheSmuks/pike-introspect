## v0.2.0 (2026-05-03)

### Features

- **Source location extraction** (#1)
  - `describe_program()`, `describe_function()`, and `describe_object()` now include `source_file` and optional `source_line` fields
  - Methods and constants returned as array of mappings with location info

- **Inheritance chain traversal** (#2)
  - `describe_program()` now includes `inherits` array with parent class info
  - `inherited_methods` and `inherited_constants` fields for parent class members

- **New `resolve_symbol()` function** (#3)
  - Cross-file identifier resolution with type and location info
  - Returns `kind` ("class", "function", "module", "variable")
  - Includes `source_file` and `source_line` for code locations

## v1.0.0 (2026-05-02)

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