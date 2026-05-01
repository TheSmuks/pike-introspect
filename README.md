# Introspect Module for Pike

## Overview

The `Introspect` module provides runtime introspection and discovery capabilities for Pike programs. It is designed to help LLM agents understand the Pike runtime environment, discover available modules, programs, functions, and constants, and retrieve detailed information about any symbol.

## Installation

### Via PMP (recommended)

```bash
pmp install TheSmuks/pike-introspect
```

Then use in your Pike code:

```pike
import Introspect;

// List all available modules
array(string) mods = Discover.list_modules();

// Get environment summary
mapping env = Describe.environment_summary();

// Search for a symbol
mapping results = Search.search("JSON");

// Get JSON output for LLM consumption
string json = Json.json_environment();
```

### Manual Installation

Copy `src/Introspect.pmod/` to your Pike module path, or set `PIKE_MODULE_PATH`:

```bash
export PIKE_MODULE_PATH=/path/to/pike-introspect/src:$PIKE_MODULE_PATH
```

## Module Structure

```
import Introspect
  ├── Discover   - Module, program, function, and constant discovery
  ├── Describe   - Detailed symbol description (type, signature, etc.)
  ├── Search     - Pattern-based search across all symbols
  └── Json       - JSON output formatters for LLM agents
```

## Quick Start

### List all importable modules

```pike
import Introspect;
array(string) modules = Discover.list_modules();
write("Available modules: %s\n", modules * ", ");
```

### Describe a symbol

```pike
import Introspect;
mixed symbol = master()->resolv("Stdio.FILE");
mapping desc = Describe.describe(symbol);
write("Symbol: %O\n", desc);
```

### Search for something

```pike
import Introspect;
mapping results = Search.search("HTTP");
write("Matching programs: %O\n", results["programs"]);
write("Matching functions: %O\n", results["functions"]);
```

### Get JSON output

```pike
import Introspect;
string json = Json.json_search("file");
write("%s\n", json);
```

## Requirements

- Pike 8.0 or later
- No external dependencies

## License

MIT
