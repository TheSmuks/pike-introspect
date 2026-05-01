# Architecture: Pike Introspection Module

## Overview

The `Introspect` module provides a unified interface for runtime introspection in Pike. It is designed to answer questions like:

- What modules are available in this Pike environment?
- What programs, functions, and constants does a module export?
- What is the type, signature, and documentation of a specific symbol?
- Which symbols match a given name pattern?

## Goals

1. **Discovery** — Find what exists in the runtime environment
2. **Description** — Provide detailed information about specific symbols
3. **Search** — Pattern-based lookup across all symbols
4. **Interoperability** — JSON output for LLM and tool consumption

## Non-Goals

- Modification of the runtime state (read-only)
- Code generation or transformation
- Source code analysis (no parsing/ast traversal)
- Debugging breakpoints or execution control

## Module Hierarchy

```
import Introspect
  ├── Discover
  │     list_modules()
  │     list_stdlib_modules()
  │     describe_module()
  │     list_programs()
  │     resolve_program()
  │     list_functions()
  │     resolve_function()
  │     list_constants()
  │     get_constants_map()
  │
  ├── Describe
  │     describe()
  │     describe_program()
  │     describe_function()
  │     describe_object()
  │     describe_module_full()
  │     environment_summary()
  │     pike_version()
  │
  ├── Search
  │     search()
  │     search_programs()
  │     search_functions()
  │     search_modules()
  │
  └── Json
        json_describe()
        json_environment()
        json_search()
        json_module()
        json_program()
        json_list_modules()
```

## Data Structures

### Module Descriptor

```pike
mapping describe_module(string name) =>
([
    "name": string,           // Module name (e.g., "Stdio")
    "programs": array(string), // Program-valued symbols
    "functions": array(string), // Function-valued symbols
    "constants": array(string), // Other public symbols
    "submodules": array(string), // Nested module names
    "path": string,           // Filesystem path (if available)
    "is_stdlib": int(0|1)     // Is this a stdlib module?
])
```

### Program Descriptor

```pike
mapping describe_program(program p) =>
([
    "name": string,           // Program name
    "type": string,           // Type description (e.g., "program")
    "methods": array(string), // Method names
    "constants": array(string), // Class constant names
    "inherits": array(string), // Parent class names
    "source": string,         // Source file (if available)
    "program_identifier": string // Unique identifier
])
```

### Function Descriptor

```pike
mapping describe_function(function f) =>
([
    "name": string,           // Function name (e.g., "Stdio.read_file")
    "type": string,            // Type string
    "signature": string,       // Human-readable signature
    "module": string           // Containing module (if known)
])
```

### Environment Summary

```pike
mapping environment_summary() =>
([
    "pike_version": string,   // Pike version string
    "module_count": int,      // Number of importable modules
    "modules": array(string), // List of module names
    "constant_count": int,    // Total constants in all_constants()
    "stdlib_modules": array(string) // Known stdlib modules
])
```

## Implementation Notes

### Pike API Constraints

The module uses only verified Pike 8.0 APIs:

| API | Purpose |
|-----|---------|
| `indices(obj)` / `values(obj)` | Enumerate object/program symbols |
| `typeof(val)` | Get type as string |
| `functionp()`, `programp()`, etc. | Type predicates |
| `object_program(obj)` | Get object's program |
| `all_constants()` | Global constant table |
| `master()->resolv(name)` | Resolve qualified paths |
| `sprintf("%O", val)` | Object description |
| `describe_backtrace(bt)` | Format backtraces |
| `callablep(val)` | Check if callable |
| `get_dir(path)` | List directory contents |

### Module Discovery

Modules are discovered by:
1. Known stdlib module names (Stdio, Standards, Protocols, etc.)
2. Directories in the Pike library path
3. Resolvable paths via `master()->resolv()`

### Program Member Enumeration

Programs don't expose `indices()` directly. To enumerate members:
1. Try `program_defined(program)` if available
2. Fallback: instantiate the program, enumerate instance symbols, destruct
3. Filter with `callablep()` for methods, `functionp()` for functions

### JSON Encoding

JSON output uses `Standards.JSON.encode()` for encoding. All mapped data structures use only JSON-compatible types (string, int, float, array, mapping, null).

## Security Considerations

- Read-only operations only — no state modification
- No file system write operations
- No network access
- No code execution beyond what Pike already allows
- No access to private symbols (only exported ones)

## Performance

- `list_modules()` caches results on first call
- `environment_summary()` does a full scan; cache if called repeatedly
- Search operations are O(n) where n = number of constants
- Consider lazy evaluation for large module trees

## Future Enhancements

- Source code location extraction (line numbers, file paths)
- Type signature parsing and display
- Inheritance chain traversal
- Method parameter documentation
- Async discovery for large module trees
