# Introspect - Pike Runtime Introspection Module

[![CI](https://github.com/TheSmuks/pike-introspect/actions/workflows/ci.yml/badge.svg)](https://github.com/TheSmuks/pike-introspect/actions/workflows/ci.yml)

Runtime introspection and discovery capabilities for Pike. Discover modules, programs, functions, and constants. Designed for LLM agents to explore the Pike environment.

## Installation

```bash
pmp install TheSmuks/pike-introspect
```

## Quick Start

```pike
import Introspect;

// List all available modules
array(string) modules = list_modules();

// Get environment summary
mapping env = environment_summary();

// Search for a symbol
mapping results = search_symbols("HTTP");

// Get JSON output for LLM consumption
string json = json_environment();
```

## Features

- **Discover** - Module, program, function, and constant discovery
- **Describe** - Detailed symbol description (type, signature, etc.)
- **Search** - Pattern-based search across all symbols
- **Json** - JSON output formatters for LLM agents

## Agent Skill

Install the agent skill via:
```bash
npx skills add TheSmuks/pike-introspect
```

## License

MIT
