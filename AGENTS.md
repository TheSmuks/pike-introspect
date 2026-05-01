# AGENTS.md — Pike Introspection Project

## Project Context

This repository (`TheSmuks/pike-introspect`) contains a standalone Pike module (`Introspect`) that provides runtime introspection and discovery capabilities. It is designed for LLM agents working with Pike code, enabling them to discover available APIs, understand type information, and explore the runtime environment.

## Repository Name

**`pike-introspect`** — The repository name on GitHub.

## What This Is

- A **PMP-installable Pike module** (`Introspect`) providing introspection APIs
- An **installable agent skill** (`pike-introspection`) for use with `npx skills add`
- Zero runtime dependencies — works anywhere Pike 8.0+ runs

## What This Is NOT

- Part of the PMP project itself (it's an installable package for PMP)
- A Pike language reference or tutorial
- A general-purpose debugging toolkit

## Module Organization

```
src/Introspect.pmod/
├── module.pmod    # Namespace — imports and re-exports all sub-modules
├── Discover.pmod  # Discovery functions (modules, programs, functions, constants)
├── Describe.pmod  # Description functions (symbol details, environment)
├── Search.pmod    # Pattern search across all symbols
└── Json.pmod      # JSON output formatters
```

## Skill Organization

```
skills/pike-introspection/
├── SKILL.md                            # Main skill definition
└── references/
    ├── introspection-api.md           # Full API reference
    └── runtime-discovery.md           # Pike's built-in introspection guide
```

## Key Design Decisions

1. **Standalone module** — No PMP runtime dependency; works in any Pike project
2. **Correct Pike 8.0 APIs only** — Uses only verified APIs: `indices()`, `values()`, `typeof()`, type predicates, `all_constants()`, `master()->resolv()`, `sprintf("%O")`, `describe_backtrace()`
3. **Sub-module architecture** — Organized by concern: Discover, Describe, Search, Json
4. **JSON output** — All results available as JSON for LLM consumption
5. **PMP-installable** — Standard `pmp install TheSmuks/pike-introspect` workflow

## Important Notes for Agents

- **Do not fabricate Pike APIs.** If something isn't listed in the references or confirmed by runtime introspection, it doesn't exist.
- **Verify before using.** Call `pike -e '...'` to test any Pike code before committing to it.
- **Use `Describe.environment_summary()` first** when exploring an unfamiliar Pike environment.
- **Use `Search.search()`** to find symbols by name pattern.
- **Use `Json.*` functions** when output needs to be consumed by another system.

## Common Patterns

### "I need to find a function that does X"
```pike
import Introspect;
mapping results = Search.search("X");
// results->functions contains matching functions
```

### "I need to check what methods are available on a class"
```pike
import Introspect;
program p = resolve_program("Stdio.File");
mapping desc = Describe.describe_program(p);
// desc->methods contains all methods
```

### "I need to understand why my code is failing"
```pike
import Introspect;
// Get backtrace as formatted string
string bt = describe_backtrace(backtrace());
// Describe the failing object
mapping desc = Describe.describe(my_object);
```

## File Paths

All file paths in this repo use POSIX conventions (forward slashes, no drive letters).

## Verification Commands

- `pike -e 'import Introspect; write("%O\n", Describe.environment_summary());'`
- `pike -e 'import Introspect; write("%s\n", Json.json_environment());'`
- `sh tests/pike_tests.sh`
