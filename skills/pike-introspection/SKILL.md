---
name: pike-introspection
description: >
  Discover and introspect Pike runtime modules, classes, functions, and constants.
  Use when you need to understand what's available in a Pike environment, find APIs,
  or determine why code might be failing due to missing symbols or wrong types.
  Triggers on: introspect, discover, what modules, what functions, API listing,
  symbol lookup, Pike environment, class hierarchy, inheritance chain.
---

# Pike Introspection Skill

## When to Use This Skill

Use this skill when:
- You need to discover what modules, programs, or functions are available
- You're debugging and need to understand the type of a value
- You need to find a specific API or function
- You want to understand the structure of a Pike module or class
- You're writing code that needs to work with dynamic symbols

## Quick Reference: CLI One-Liners

```bash
# List available modules
pike -e 'import Introspect; write("%O\n", list_modules());'

# Get environment summary
pike -e 'import Introspect; write("%O\n", environment_summary());'

# Search for something
pike -e 'import Introspect; write("%O\n", search_symbols("HTTP"));'

# Describe a specific program
pike -e 'import Introspect; write("%O\n", describe_program(Stdio.File));'

# Get JSON output
pike -e 'import Introspect; write("%s\n", json_environment());'
```

## Using the Introspect PMP Module

### Installation

```bash
pmp install TheSmuks/pike-introspect
```

Then in your Pike code:

```pike
import Introspect;

// Discovery functions
array(string) modules = list_modules();
mapping desc = describe_module("Stdio");
array(string) progs = list_programs(Stdio);
array(string) fns = list_functions(Stdio);

// Description functions
mapping env = environment_summary();
mapping sym = describe(some_value);
mapping prog = describe_program(Stdio.File);

// Search functions
mapping results = search_symbols("pattern");

// JSON output (for LLM consumption)
string json = json_environment();
```

## Pike's Built-in Introspection API

### Enumeration

```pike
// Get all symbols of an object/program
array idx = indices(my_object);  // Symbol names
array vals = values(my_object);  // Symbol values

// Type checking
functionp(val)      // Is it a function?
programp(val)        // Is it a program (class)?
objectp(val)         // Is it an object?
stringp(val)         // Is it a string?
intp(val)            // Is it an integer?
arrayp(val)          // Is it an array?
mappingp(val)        // Is it a mapping?
callablep(val)       // Is it callable?
```

### Type Information

```pike
// Get type as string
string type = sprintf("%t", value);  // "int", "string", "function", etc.

// Get type as descriptive string
string desc = sprintf("%O", value);  // Full description including path
```

### Environment

```pike
// Global constants table
mapping c = all_constants();

// Resolve qualified paths
mixed val = master()->resolv("Stdio.read_file");

// Current backtrace
array bt = backtrace();

// Format backtrace
string formatted = describe_backtrace(bt);
```

### Object Information

```pike
// Get an object's program
program p = object_program(my_object);

// Describe a program (if it can be instantiated)
object inst = program();
array members = indices(inst);
destruct(inst);
```

## Common Patterns

### "I need to find a function that does X"

```pike
import Introspect;
mapping results = search_symbols("X");
// results->functions contains matching functions
```

### "I need to check what methods are available on a class"

```pike
import Introspect;
program p = resolve_program("Stdio.File");
mapping desc = describe_program(p);
// desc->methods contains all method names
```

### "I need to understand why my code is failing"

```pike
import Introspect;
// Get formatted backtrace
string bt = describe_backtrace(backtrace());
// Describe the failing value
mapping desc = describe(my_value);
```

### "I need to check if a module is available"

```pike
import Introspect;
array mods = list_modules();
if (has_value(mods, "SomeModule")) {
    // Module exists
}
```

## Reference Files

- [Introspection API Reference](references/introspection-api.md) - Full API documentation
- [Runtime Discovery Guide](references/runtime-discovery.md) - Detailed guide to Pike's introspection capabilities

## Notes

- Do NOT fabricate Pike APIs. If something isn't listed in the references or confirmed by runtime introspection, it doesn't exist.
- Always verify APIs exist by running `pike -e '...'` before using them.
- Use `json_*` functions when output needs to be consumed by other systems (like LLM agents).
