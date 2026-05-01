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

// Inherit in specific order to ensure dependencies are resolved correctly.
// Json.pmod is inherited first because it doesn't depend on other modules.
// Describe, Search, and Discover have no circular dependencies.
inherit .Json;
inherit .Describe;
inherit .Search;
inherit .Discover;
