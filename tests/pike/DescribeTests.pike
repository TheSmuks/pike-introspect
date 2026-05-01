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
