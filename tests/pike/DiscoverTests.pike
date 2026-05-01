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
