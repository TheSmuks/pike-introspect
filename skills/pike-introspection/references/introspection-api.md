# Introspection API Reference

## Module: `Introspect`

The `Introspect` module provides runtime introspection and discovery capabilities for Pike.

### Installation

```bash
pmp install TheSmuks/pike-introspect
```

### Quick Start

```pike
import Introspect;
```

---

## Discover Module

Functions for discovering modules, programs, functions, and constants.

### `list_modules()`

```pike
array(string) list_modules()
```

Returns all importable modules in the current Pike environment.

**Returns:** Array of module names

**Example:**
```pike
array(string) mods = list_modules();
// ({ "Stdio", "Standards", "Protocols", ... })
```

---

### `list_stdlib_modules()`

```pike
array(string) list_stdlib_modules()
```

Returns known stdlib module names.

**Returns:** Array of known stdlib module names

---

### `describe_module(string name)`

```pike
mapping describe_module(string name)
```

Get a description of a module including its programs, functions, and constants.

**Parameters:**
- `name`: Module name to describe

**Returns:** Mapping with keys:
- `name`: Module name
- `programs`: Array of program-valued symbols
- `functions`: Array of function-valued symbols
- `constants`: Array of other public symbols
- `submodules`: Array of nested module names
- `is_stdlib`: 1 if this is a known stdlib module, 0 otherwise

---

### `list_programs(object|program mod)`

```pike
array(string) list_programs(object|program mod)
```

List all program-valued symbols in a module or object.

**Parameters:**
- `mod`: The module or object to inspect

**Returns:** Array of program symbol names

---

### `resolve_program(string path)`

```pike
program|void resolve_program(string path)
```

Resolve a qualified program path.

**Parameters:**
- `path`: Program path like `"Stdio.File"` or `"Protocols.HTTP.Query"`

**Returns:** The resolved program, or UNDEFINED if not found

---

### `list_functions(object|program mod)`

```pike
array(string) list_functions(object|program mod)
```

List all function-valued symbols in a module or object.

**Parameters:**
- `mod`: The module or object to inspect

**Returns:** Array of function symbol names

---

### `resolve_function(string path)`

```pike
function|void resolve_function(string path)
```

Resolve a qualified function path.

**Parameters:**
- `path`: Function path like `"Stdio.read_file"`

**Returns:** The resolved function, or UNDEFINED if not found

---

### `list_constants(object|program mod)`

```pike
array(string) list_constants(object|program mod)
```

List non-function, non-program public symbols in a module.

**Parameters:**
- `mod`: The module or object to inspect

**Returns:** Array of constant symbol names

---

### `get_constants_map(object|program mod)`

```pike
mapping(string:mixed) get_constants_map(object|program mod)
```

Get a mapping of constant names to values.

**Parameters:**
- `mod`: The module or object to inspect

**Returns:** Mapping of constant name to value

---

## Describe Module

Functions for describing symbols in detail.

### `describe(mixed val)`

```pike
mapping describe(mixed val)
```

Universal describe function that dispatches based on type.

**Parameters:**
- `val`: The value to describe

**Returns:** Mapping with type-specific description

---

### `describe_function(function f)`

```pike
mapping describe_function(function f)
```

Describe a function in detail.

**Parameters:**
- `f`: The function to describe

**Returns:** Mapping with keys:
- `name`: Function name
- `type`: "function"
- `signature`: Human-readable signature

---

### `describe_program(program p)`

```pike
mapping describe_program(program p)
```

Describe a program (class) in detail.

**Parameters:**
- `p`: The program to describe

**Returns:** Mapping with keys:
- `name`: Program name
- `type`: "program"
- `methods`: Array of method names
- `constants`: Array of class constant names

---

### `describe_object(object o)`

```pike
mapping describe_object(object o)
```

Describe an object in detail.

**Parameters:**
- `o`: The object to describe

**Returns:** Mapping with keys:
- `program`: The object's program
- `type`: "object"
- `methods`: Array of method names
- `variables`: Array of variable names

---

### `describe_module_full(string name)`

```pike
mapping describe_module_full(string name)
```

Describe a module in full detail.

**Parameters:**
- `name`: The module name to describe

**Returns:** Mapping with complete module information including:
- `name`, `type`, `programs`, `functions`, `objects`, `constants`, `submodules`

---

### `environment_summary()`

```pike
mapping environment_summary()
```

Get a summary of the Pike environment.

**Returns:** Mapping with keys:
- `pike_version`: Pike version string
- `module_count`: Number of importable modules
- `modules`: Array of available module names
- `stdlib_modules`: Array of known stdlib module names
- `constant_count`: Total constants in all_constants()

---

### `pike_version()`

```pike
string pike_version()
```

Get the Pike version as a string.

**Returns:** Pike version string

---

## Search Module

Functions for pattern-based search across all symbols.

### `search_symbols(string pattern)`

```pike
mapping search_symbols(string pattern)
```

Search all symbols matching a pattern (case-insensitive substring match).

**Parameters:**
- `pattern`: Substring pattern to search for

**Returns:** Mapping with keys:
- `modules`: Array of matching module names
- `programs`: Array of matching program paths
- `functions`: Array of matching function paths
- `pattern`: The original search pattern

---

### `search_modules(string pattern)`

```pike
array(string) search_modules(string pattern)
```

Search for modules matching a pattern.

**Parameters:**
- `pattern`: Substring pattern to search for

**Returns:** Array of matching module names

---

### `search_programs(string pattern)`

```pike
array(string) search_programs(string pattern)
```

Search for programs matching a pattern.

**Parameters:**
- `pattern`: Substring pattern to search for

**Returns:** Array of matching program paths (e.g., `"Stdio.FakeFile"`)

---

### `search_functions(string pattern)`

```pike
array(string) search_functions(string pattern)
```

Search for functions matching a pattern.

**Parameters:**
- `pattern`: Substring pattern to search for

**Returns:** Array of matching function paths (e.g., `"Stdio.read_file"`)

---

### `search_constants(string pattern)`

```pike
array(string) search_constants(string pattern)
```

Search for constants matching a pattern.

**Parameters:**
- `pattern`: Substring pattern to search for

**Returns:** Array of matching constant names

---

## Json Module

Functions for producing JSON output suitable for LLM consumption.

### `to_jsonable(mixed val)`

```pike
mixed to_jsonable(mixed val)
```

Convert any value to a JSON-encodable representation.

**Parameters:**
- `val`: The value to convert

**Returns:** A JSON-encodable value (string, int, float, array, mapping, or UNDEFINED/null)

---

### `json_describe(mixed val)`

```pike
string json_describe(mixed val)
```

Get JSON description of any value.

**Parameters:**
- `val`: The value to describe

**Returns:** JSON-encoded description string

---

### `json_environment()`

```pike
string json_environment()
```

Get JSON representation of the Pike environment.

**Returns:** JSON-encoded environment summary

---

### `json_search(string pattern)`

```pike
string json_search(string pattern)
```

Get JSON search results.

**Parameters:**
- `pattern`: Pattern to search for

**Returns:** JSON-encoded search results

---

### `json_module(string name)`

```pike
string json_module(string name)
```

Get JSON description of a module.

**Parameters:**
- `name`: Module name to describe

**Returns:** JSON-encoded module description

---

### `json_program(string path)`

```pike
string json_program(string path)
```

Get JSON description of a program.

**Parameters:**
- `path`: Program path like `"Stdio.File"`

**Returns:** JSON-encoded program description, or UNDEFINED if not found

---

### `json_list_modules()`

```pike
string json_list_modules()
```

Get JSON list of available modules.

**Returns:** JSON-encoded array of module names

---

### `json_function(string path)`

```pike
string json_function(string path)
```

Get JSON description of a function.

**Parameters:**
- `path`: Function path like `"Stdio.read_file"`

**Returns:** JSON-encoded function description, or UNDEFINED if not found

---

## Type Predicates Reference

Use these built-in Pike functions to check types:

| Function | Description |
|----------|-------------|
| `functionp(val)` | Returns true if val is a function |
| `programp(val)` | Returns true if val is a program |
| `objectp(val)` | Returns true if val is an object |
| `stringp(val)` | Returns true if val is a string |
| `intp(val)` | Returns true if val is an integer |
| `floatp(val)` | Returns true if val is a float |
| `arrayp(val)` | Returns true if val is an array |
| `mappingp(val)` | Returns true if val is a mapping |
| `multisetp(val)` | Returns true if val is a multiset |
| `callablep(val)` | Returns true if val is callable |
| `undefinedp(val)` | Returns true if val is UNDEFINED |
