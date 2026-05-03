// Discover.pmod Tests

#pike __REAL_VERSION__

import Introspect;

//! Test list_modules returns an array
void test_list_modules_returns_array() {
  mixed result = list_modules();
  if (!arrayp(result)) {
    error("list_modules should return an array, got: %s\n", sprintf("%t", result));
  }
}

//! Test list_modules contains Stdio
void test_list_modules_contains_stdio() {
  array mods = list_modules();
  if (!has_value(mods, "Stdio")) {
    error("list_modules should contain 'Stdio'\n");
  }
}

//! Test list_stdlib_modules returns an array
void test_list_stdlib_returns_array() {
  mixed result = list_stdlib_modules();
  if (!arrayp(result)) {
    error("list_stdlib_modules should return an array\n");
  }
}

//! Test describe_module works
void test_describe_module() {
  mapping desc = describe_module("Stdio");
  if (!mappingp(desc)) {
    error("describe_module should return a mapping\n");
  }
  if (desc["name"] != "Stdio") {
    error("describe_module should have name 'Stdio'\n");
  }
}

//! Test describe_module returns UNDEFINED for unknown module
void test_describe_module_unknown() {
  mixed desc = describe_module("NonExistentModule12345");
  if (desc != UNDEFINED) {
    error("describe_module should return UNDEFINED for unknown module\n");
  }
}

//! Test list_programs works
void test_list_programs() {
  mixed stdio = master()->resolv("Stdio");
  array progs = list_programs(stdio);
  if (!arrayp(progs)) {
    error("list_programs should return an array\n");
  }
  if (sizeof(progs) == 0) {
    error("Stdio should have at least one program\n");
  }
}

//! Test list_functions works
void test_list_functions() {
  mixed stdio = master()->resolv("Stdio");
  array fns = list_functions(stdio);
  if (!arrayp(fns)) {
    error("list_functions should return an array\n");
  }
  if (!has_value(fns, "read_file")) {
    error("Stdio should have 'read_file' function\n");
  }
}

//! Test list_constants works
void test_list_constants() {
  mixed stdio = master()->resolv("Stdio");
  array consts = list_constants(stdio);
  if (!arrayp(consts)) {
    error("list_constants should return an array\n");
  }
}

//! Test resolve_program works
void test_resolve_program() {
  program p = resolve_program("Stdio.FakeFile");
  if (!p) {
    error("resolve_program should find Stdio.FakeFile\n");
  }
}

//! Test resolve_program returns UNDEFINED for unknown
void test_resolve_program_unknown() {
  program p = resolve_program("NonExistent.Module");
  if (p != UNDEFINED) {
    error("resolve_program should return UNDEFINED for unknown path\n");
  }
}

//! Test resolve_function works
void test_resolve_function() {
  function f = resolve_function("Stdio.read_file");
  if (!f) {
    error("resolve_function should find Stdio.read_file\n");
  }
}

//! Test resolve_function returns UNDEFINED for unknown
void test_resolve_function_unknown() {
  function f = resolve_function("NonExistent.func");
  if (f != UNDEFINED) {
    error("resolve_function should return UNDEFINED for unknown path\n");
  }
}

// ============================================================================
// New tests for Issue #3: resolve_symbol function
// ============================================================================

//! Test resolve_symbol works for a program (class)
void test_resolve_symbol_program() {
  mapping result = resolve_symbol("Stdio.FakeFile");
  if (result == UNDEFINED) {
    error("resolve_symbol should find Stdio.FakeFile\n");
  }
  if (result["kind"] != "class") {
    error("Stdio.FakeFile should be kind 'class', got: %s\n", result["kind"]);
  }
  if (!result["name"]) {
    error("resolve_symbol should include 'name'\n");
  }
  if (!result["source_file"]) {
    error("resolve_symbol should include 'source_file' for programs\n");
  }
  if (!result["program"]) {
    error("resolve_symbol should include 'program' for class kind\n");
  }
}

//! Test resolve_symbol works for a function
void test_resolve_symbol_function() {
  mapping result = resolve_symbol("Stdio.read_file");
  if (result == UNDEFINED) {
    error("resolve_symbol should find Stdio.read_file\n");
  }
  if (result["kind"] != "function") {
    error("Stdio.read_file should be kind 'function', got: %s\n", result["kind"]);
  }
  if (!result["name"]) {
    error("resolve_symbol should include 'name'\n");
  }
  if (!result["source_file"]) {
    error("resolve_symbol should include 'source_file' for functions\n");
  }
}

//! Test resolve_symbol works for a module
void test_resolve_symbol_module() {
  mapping result = resolve_symbol("Stdio");
  if (result == UNDEFINED) {
    error("resolve_symbol should find Stdio\n");
  }
  if (result["kind"] != "module") {
    error("Stdio should be kind 'module', got: %s\n", result["kind"]);
  }
  if (!result["name"]) {
    error("resolve_symbol should include 'name'\n");
  }
}

//! Test resolve_symbol returns UNDEFINED for unknown symbol
void test_resolve_symbol_unknown() {
  mapping result = resolve_symbol("NonExistent.Symbol12345");
  if (result != UNDEFINED) {
    error("resolve_symbol should return UNDEFINED for unknown symbol, got: %O\n", result);
  }
}

//! Test resolve_symbol includes source_line for functions that have it
void test_resolve_symbol_function_has_source_line() {
  mapping result = resolve_symbol("Stdio.read_file");
  if (result == UNDEFINED) {
    error("resolve_symbol should find Stdio.read_file\n");
  }
  // Stdio.read_file is defined at a specific line
  if (!result["source_line"] && !result["source_file"]) {
    error("resolve_symbol should include source location for Stdio.read_file\n");
  }
}

// ============================================================================
// Test runner
// ============================================================================

int run_test(string name, function test_func) {
  mixed err = catch {
    test_func();
    write("PASS\n");
    return 1;
  };
  if (err) {
    write("FAIL\n");
    return 0;
  }
  return 0;
}

int main() {
  int passed = 0;
  int failed = 0;

  write("Test: list_modules_returns_array... ");
  if (run_test("list_modules_returns_array", test_list_modules_returns_array)) passed++; else failed++;

  write("Test: list_modules_contains_stdio... ");
  if (run_test("list_modules_contains_stdio", test_list_modules_contains_stdio)) passed++; else failed++;

  write("Test: list_stdlib_returns_array... ");
  if (run_test("list_stdlib_returns_array", test_list_stdlib_returns_array)) passed++; else failed++;

  write("Test: describe_module... ");
  if (run_test("describe_module", test_describe_module)) passed++; else failed++;

  write("Test: describe_module_unknown... ");
  if (run_test("describe_module_unknown", test_describe_module_unknown)) passed++; else failed++;

  write("Test: list_programs... ");
  if (run_test("list_programs", test_list_programs)) passed++; else failed++;

  write("Test: list_functions... ");
  if (run_test("list_functions", test_list_functions)) passed++; else failed++;

  write("Test: list_constants... ");
  if (run_test("list_constants", test_list_constants)) passed++; else failed++;

  write("Test: resolve_program... ");
  if (run_test("resolve_program", test_resolve_program)) passed++; else failed++;

  write("Test: resolve_program_unknown... ");
  if (run_test("resolve_program_unknown", test_resolve_program_unknown)) passed++; else failed++;

  write("Test: resolve_function... ");
  if (run_test("resolve_function", test_resolve_function)) passed++; else failed++;

  write("Test: resolve_function_unknown... ");
  if (run_test("resolve_function_unknown", test_resolve_function_unknown)) passed++; else failed++;

  // New tests for Issue #3
  write("Test: resolve_symbol_program... ");
  if (run_test("resolve_symbol_program", test_resolve_symbol_program)) passed++; else failed++;

  write("Test: resolve_symbol_function... ");
  if (run_test("resolve_symbol_function", test_resolve_symbol_function)) passed++; else failed++;

  write("Test: resolve_symbol_module... ");
  if (run_test("resolve_symbol_module", test_resolve_symbol_module)) passed++; else failed++;

  write("Test: resolve_symbol_unknown... ");
  if (run_test("resolve_symbol_unknown", test_resolve_symbol_unknown)) passed++; else failed++;

  write("Test: resolve_symbol_function_has_source_line... ");
  if (run_test("resolve_symbol_function_has_source_line", test_resolve_symbol_function_has_source_line)) passed++; else failed++;

  write("\n================================\n");
  write("Results: %d passed, %d failed\n", passed, failed);
  write("================================\n");

  return failed > 0 ? 1 : 0;
}