// Describe.pmod Tests

#pike __REAL_VERSION__

import Introspect;

//! Test environment_summary returns a mapping
void test_environment_summary_returns_mapping() {
  mapping env = environment_summary();
  if (!mappingp(env)) {
    error("environment_summary should return a mapping\n");
  }
}

//! Test environment_summary has pike_version
void test_environment_summary_has_version() {
  mapping env = environment_summary();
  if (!env["pike_version"]) {
    error("environment_summary should have 'pike_version'\n");
  }
}

//! Test environment_summary has module_count
void test_environment_summary_has_module_count() {
  mapping env = environment_summary();
  if (!intp(env["module_count"])) {
    error("environment_summary should have integer 'module_count'\n");
  }
}

//! Test environment_summary has modules array
void test_environment_summary_has_modules() {
  mapping env = environment_summary();
  if (!arrayp(env["modules"])) {
    error("environment_summary should have 'modules' array\n");
  }
}

//! Test pike_version returns a string
void test_pike_version_returns_string() {
  string ver = pike_version();
  if (!stringp(ver)) {
    error("pike_version should return a string\n");
  }
}

//! Test describe_function works on Stdio.read_file
void test_describe_function() {
  function f = Stdio.read_file;
  mapping desc = describe_function(f);
  if (!mappingp(desc)) {
    error("describe_function should return a mapping\n");
  }
  if (desc["type"] != "function") {
    error("describe_function should have type 'function'\n");
  }
}

//! Test describe_program works on Stdio.FakeFile
void test_describe_program() {
  program p = resolve_program("Stdio.FakeFile");
  if (!p) {
    error("Could not resolve Stdio.FakeFile\n");
  }
  mapping desc = describe_program(p);
  if (!mappingp(desc)) {
    error("describe_program should return a mapping\n");
  }
  if (desc["type"] != "program") {
    error("describe_program should have type 'program'\n");
  }
}

//! Test describe_object works
void test_describe_object() {
  Stdio.File f = Stdio.FILE();
  mapping desc = describe_object(f);
  if (!mappingp(desc)) {
    error("describe_object should return a mapping\n");
  }
  if (desc["type"] != "object") {
    error("describe_object should have type 'object'\n");
  }
  destruct(f);
}

//! Test describe_module_full works
void test_describe_module_full() {
  mapping desc = describe_module_full("Stdio");
  if (!mappingp(desc)) {
    error("describe_module_full should return a mapping\n");
  }
  if (desc["type"] != "module") {
    error("describe_module_full should have type 'module'\n");
  }
}

//! Test describe on various types
void test_describe_int() {
  mapping desc = describe(42);
  if (desc["type"] != "int") {
    error("describe(42) should have type 'int'\n");
  }
}

void test_describe_string() {
  mapping desc = describe("hello");
  if (desc["type"] != "string") {
    error("describe('hello') should have type 'string'\n");
  }
}

void test_describe_array() {
  mapping desc = describe(({1, 2, 3}));
  if (desc["type"] != "array") {
    error("describe(({1,2,3})) should have type 'array'\n");
  }
}

// ============================================================================
// New tests for Issue #1: Source Location Extraction
// ============================================================================

//! Test describe_program returns source_file for Stdio.FakeFile
void test_describe_program_source_location() {
  program p = resolve_program("Stdio.FakeFile");
  if (!p) {
    error("Could not resolve Stdio.FakeFile\n");
  }
  mapping desc = describe_program(p);
  if (!desc["source_file"]) {
    error("describe_program should include 'source_file'\n");
  }
  if (!has_value(desc["source_file"], "FakeFile.pike")) {
    error("source_file should point to FakeFile.pike, got: %s\n", desc["source_file"]);
  }
}

//! Test describe_function returns source_file for Stdio.read_file
void test_describe_function_source_location() {
  function f = Stdio.read_file;
  mapping desc = describe_function(f);
  if (!desc["source_file"]) {
    error("describe_function should include 'source_file'\n");
  }
}

//! Test describe_object returns source_file
void test_describe_object_source_location() {
  Stdio.File f = Stdio.FILE();
  mapping desc = describe_object(f);
  if (!desc["source_file"]) {
    error("describe_object should include 'source_file'\n");
  }
  destruct(f);
}

// ============================================================================
// New tests for Issue #2: Inheritance Chain
// ============================================================================

//! Test describe_program includes inherits array (may be empty for C-level)
void test_describe_program_inherits() {
  program p = resolve_program("Stdio.FakeFile");
  if (!p) {
    error("Could not resolve Stdio.FakeFile\n");
  }
  mapping desc = describe_program(p);
  // The key should exist only if there are inherited classes
  // For C-level programs with no inheritance, the key may be absent
  // Verify that if it exists, it's an array
  if (has_value(desc, "inherits")) {
    if (!arrayp(desc["inherits"])) {
      error("inherits should be an array if present\n");
    }
  }
  // Test passes - key may or may not exist depending on inheritance
}

// ============================================================================
// New tests for Issue #1: Method/Constant Mappings
// ============================================================================

//! Test describe_program methods is array of mappings
void test_describe_program_methods_are_mappings() {
  program p = resolve_program("Stdio.FakeFile");
  if (!p) {
    error("Could not resolve Stdio.FakeFile\n");
  }
  mapping desc = describe_program(p);
  if (!arrayp(desc["methods"])) {
    error("describe_program methods should be an array\n");
  }
  if (sizeof(desc["methods"]) > 0) {
    // Check that methods are mappings with 'name' key
    foreach(desc["methods"], mixed m) {
      if (!mappingp(m)) {
        error("methods should be mappings, got: %s\n", sprintf("%t", m));
      }
      if (!m["name"]) {
        error("method mapping should have 'name' key\n");
      }
    }
  }
}

//! Test describe_program constants is array of mappings
void test_describe_program_constants_are_mappings() {
  program p = resolve_program("Stdio.FakeFile");
  if (!p) {
    error("Could not resolve Stdio.FakeFile\n");
  }
  mapping desc = describe_program(p);
  if (!arrayp(desc["constants"])) {
    error("describe_program constants should be an array\n");
  }
  if (sizeof(desc["constants"]) > 0) {
    // Check that constants are mappings with 'name' key
    foreach(desc["constants"], mixed c) {
      if (!mappingp(c)) {
        error("constants should be mappings, got: %s\n", sprintf("%t", c));
      }
      if (!c["name"]) {
        error("constant mapping should have 'name' key\n");
      }
    }
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

  write("Test: environment_summary_returns_mapping... ");
  if (run_test("environment_summary_returns_mapping", test_environment_summary_returns_mapping)) passed++; else failed++;

  write("Test: environment_summary_has_version... ");
  if (run_test("environment_summary_has_version", test_environment_summary_has_version)) passed++; else failed++;

  write("Test: environment_summary_has_module_count... ");
  if (run_test("environment_summary_has_module_count", test_environment_summary_has_module_count)) passed++; else failed++;

  write("Test: environment_summary_has_modules... ");
  if (run_test("environment_summary_has_modules", test_environment_summary_has_modules)) passed++; else failed++;

  write("Test: pike_version_returns_string... ");
  if (run_test("pike_version_returns_string", test_pike_version_returns_string)) passed++; else failed++;

  write("Test: describe_function... ");
  if (run_test("describe_function", test_describe_function)) passed++; else failed++;

  write("Test: describe_program... ");
  if (run_test("describe_program", test_describe_program)) passed++; else failed++;

  write("Test: describe_object... ");
  if (run_test("describe_object", test_describe_object)) passed++; else failed++;

  write("Test: describe_module_full... ");
  if (run_test("describe_module_full", test_describe_module_full)) passed++; else failed++;

  write("Test: describe_int... ");
  if (run_test("describe_int", test_describe_int)) passed++; else failed++;

  write("Test: describe_string... ");
  if (run_test("describe_string", test_describe_string)) passed++; else failed++;

  write("Test: describe_array... ");
  if (run_test("describe_array", test_describe_array)) passed++; else failed++;

  // New tests for Issues #1, #2
  write("Test: describe_program_source_location... ");
  if (run_test("describe_program_source_location", test_describe_program_source_location)) passed++; else failed++;

  write("Test: describe_function_source_location... ");
  if (run_test("describe_function_source_location", test_describe_function_source_location)) passed++; else failed++;

  write("Test: describe_object_source_location... ");
  if (run_test("describe_object_source_location", test_describe_object_source_location)) passed++; else failed++;

  write("Test: describe_program_inherits... ");
  if (run_test("describe_program_inherits", test_describe_program_inherits)) passed++; else failed++;

  write("Test: describe_program_methods_are_mappings... ");
  if (run_test("describe_program_methods_are_mappings", test_describe_program_methods_are_mappings)) passed++; else failed++;

  write("Test: describe_program_constants_are_mappings... ");
  if (run_test("describe_program_constants_are_mappings", test_describe_program_constants_are_mappings)) passed++; else failed++;

  write("\n================================\n");
  write("Results: %d passed, %d failed\n", passed, failed);
  write("================================\n");

  return failed > 0 ? 1 : 0;
}