// Test runner for Introspect module
// Uses PUnit for testing

#pike __REAL_VERSION__

int main(int argc, array(string) argv) {
  write("Introspect Module Test Runner\n");
  write("================================\n\n");
  
  // Add module paths
  add_module_path("src");
  
  // Import the module
  import Introspect;
  
  // Run basic validation tests
  int passed = 0;
  int failed = 0;
  
  // Test 1: environment_summary
  write("Test: environment_summary... ");
  mapping env = environment_summary();
  if (mappingp(env) && env["pike_version"]) {
    write("PASS\n");
    passed++;
  } else {
    write("FAIL\n");
    failed++;
  }
  
  // Test 2: list_modules
  write("Test: list_modules... ");
  array mods = list_modules();
  if (arrayp(mods) && sizeof(mods) > 0 && has_value(mods, "Stdio")) {
    write("PASS (%d modules)\n", sizeof(mods));
    passed++;
  } else {
    write("FAIL\n");
    failed++;
  }
  
  // Test 3: list_stdlib_modules
  write("Test: list_stdlib_modules... ");
  array stdlib = list_stdlib_modules();
  if (arrayp(stdlib) && sizeof(stdlib) > 0) {
    write("PASS (%d modules)\n", sizeof(stdlib));
    passed++;
  } else {
    write("FAIL\n");
    failed++;
  }
  
  // Test 4: describe_module
  write("Test: describe_module... ");
  mapping desc = describe_module("Stdio");
  if (mappingp(desc) && desc["name"] == "Stdio") {
    write("PASS\n");
    passed++;
  } else {
    write("FAIL\n");
    failed++;
  }
  
  // Test 5: search_symbols
  write("Test: search_symbols... ");
  mapping results = search_symbols("File");
  if (mappingp(results) && arrayp(results["programs"])) {
    write("PASS (%d programs found)\n", sizeof(results["programs"]));
    passed++;
  } else {
    write("FAIL\n");
    failed++;
  }
  
  // Test 6: describe_function
  write("Test: describe_function... ");
  function f = Stdio.read_file;
  mapping func_desc = describe_function(f);
  if (mappingp(func_desc) && func_desc["type"] == "function") {
    write("PASS\n");
    passed++;
  } else {
    write("FAIL\n");
    failed++;
  }
  
  // Test 7: json_environment
  write("Test: json_environment... ");
  string json = json_environment();
  if (stringp(json) && sizeof(json) > 0) {
    write("PASS (length: %d)\n", sizeof(json));
    passed++;
  } else {
    write("FAIL\n");
    failed++;
  }
  
  // Test 8: json_search
  write("Test: json_search... ");
  string json_search = json_search("read");
  if (stringp(json_search) && sizeof(json_search) > 0) {
    write("PASS (length: %d)\n", sizeof(json_search));
    passed++;
  } else {
    write("FAIL\n");
    failed++;
  }
  
  // Summary
  write("\n================================\n");
  write("Results: %d passed, %d failed\n", passed, failed);
  write("================================\n");
  
  return failed > 0 ? 1 : 0;
}
