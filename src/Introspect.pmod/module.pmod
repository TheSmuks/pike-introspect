// Introspect.pmod/module.pmod
// Main namespace module
// Pike module path should include src/ directory

#pike __REAL_VERSION__

//! The Introspect module provides runtime introspection and discovery
//! capabilities for Pike. It allows LLM agents to explore the Pike runtime
//! environment, discover modules, programs, functions, and constants, and
//! retrieve detailed information about any symbol.
//!
//! @section

// Inherit the sub-modules. In Pike's pmod system, these become part of
// this module's namespace.
inherit .Discover;
inherit .Describe;
inherit .Search;
inherit .Json;
