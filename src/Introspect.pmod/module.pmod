// Introspect.pmod/module.pmod
// Namespace module that inherits all sub-modules

//! The Introspect module provides runtime introspection and discovery
//! capabilities for Pike. It allows LLM agents to explore the Pike runtime
//! environment, discover modules, programs, functions, and constants, and
//! retrieve detailed information about any symbol.
//!
//! @section

inherit .Discover : Discover;
inherit .Describe : Describe;
inherit .Search : Search;
inherit .Json : Json;
