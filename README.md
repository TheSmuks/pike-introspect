# Introspect Module for Pike

[![CI](https://github.com/TheSmuks/pike-introspect/actions/workflows/ci.yml/badge.svg)](https://github.com/TheSmuks/pike-introspect/actions/workflows/ci.yml)

Runtime introspection and discovery capabilities for Pike. Designed for LLM agents to explore the Pike environment, discover modules, programs, functions, and constants.

## Installation

### Via PMP (recommended)

```bash
# Install PMP if you haven't already
curl -LsSf https://github.com/TheSmuks/pmp/install.sh | sh

# Install Introspect
pmp install TheSmuks/pike-introspect
```

### Manual Installation

```bash
export PIKE_MODULE_PATH=/path/to/pike-introspect/src:$PIKE_MODULE_PATH
```

Then in your Pike code:

```pike
import Introspect;

// List all available modules
array(string) mods = list_modules();

// Get environment summary
mapping env = environment_summary();

// Search for a symbol
mapping results = search_symbols("HTTP");

// Get JSON output for LLM consumption
string json = json_environment();
```

## Module Structure

```
import Introspect
  ├── Discover   - Module, program, function, and constant discovery
  ├── Describe   - Detailed symbol description (type, signature, etc.)
  ├── Search     - Pattern-based search across all symbols
  └── Json       - JSON output formatters for LLM agents
```

## Quick Examples

### List Modules

```pike
import Introspect;

array(string) modules = list_modules();
write("Available modules: %s\n", modules * ", ");
```

### Describe a Symbol

```pike
import Introspect;

mixed symbol = master()->resolv("Stdio.FILE");
mapping desc = describe(symbol);
write("Symbol: %O\n", desc);
```

### Search for Functions

```pike
import Introspect;

mapping results = search_symbols("read");
write("Matching functions: %O\n", results["functions"]);
```

### Get JSON Output

```pike
import Introspect;

string json = json_search("file");
write("%s\n", json);
```

## API Reference

See [skills/pike-introspection/references/introspection-api.md](skills/pike-introspection/references/introspection-api.md) for the full API documentation.

## Agent Skill

This module includes an agent skill for LLM agents. Install via:

```bash
npx skills add TheSmuks/pike-introspect
```

See [skills/pike-introspection/SKILL.md](skills/pike-introspection/SKILL.md) for usage.

## Requirements

- Pike 8.0 or later
- PMP (for dependency management) - optional but recommended

## License

MIT
