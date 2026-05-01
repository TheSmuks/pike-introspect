// Search.pmod Tests

#pike __REAL_VERSION__

import Introspect;

//! Test search_symbols returns a mapping
void test_search_symbols_returns_mapping() {
  mapping results = search_symbols("File");
  if (!mappingp(results)) {
    error("search_symbols should return a mapping\n");
  }
}

//! Test search_symbols has pattern
void test_search_symbols_has_pattern() {
  mapping results = search_symbols("test");
  if (results["pattern"] != "test") {
    error("search_symbols should preserve the pattern\n");
  }
}

//! Test search_symbols has arrays
void test_search_symbols_has_arrays() {
  mapping results = search_symbols("File");
  if (!arrayp(results["modules"])) {
    error("search_symbols should have 'modules' array\n");
  }
  if (!arrayp(results["programs"])) {
    error("search_symbols should have 'programs' array\n");
  }
  if (!arrayp(results["functions"])) {
    error("search_symbols should have 'functions' array\n");
  }
}

//! Test search_modules finds modules
void test_search_modules() {
  array results = search_modules("Stdio");
  if (!has_value(results, "Stdio")) {
    error("search_modules should find 'Stdio'\n");
  }
}

//! Test search_modules is case-insensitive
void test_search_modules_case_insensitive() {
  array results = search_modules("STDIO");
  if (!has_value(results, "Stdio")) {
    error("search_modules should be case-insensitive\n");
  }
}

//! Test search_programs finds programs
void test_search_programs() {
  array results = search_programs("File");
  if (sizeof(results) == 0) {
    error("search_programs should find programs with 'File' in name\n");
  }
}

//! Test search_functions finds functions
void test_search_functions() {
  array results = search_functions("read");
  if (sizeof(results) == 0) {
    error("search_functions should find functions with 'read' in name\n");
  }
}

//! Test search_constants finds constants
void test_search_constants() {
  array results = search_constants("true");
  if (sizeof(results) == 0) {
    error("search_constants should find constants with 'true' in name\n");
  }
}
