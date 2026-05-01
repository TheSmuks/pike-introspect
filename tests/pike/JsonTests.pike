// Json.pmod Tests

#pike __REAL_VERSION__

import Introspect;

//! Test to_jsonable converts int
void test_to_jsonable_int() {
  mixed result = to_jsonable(42);
  if (result != 42) {
    error("to_jsonable(42) should return 42\n");
  }
}

//! Test to_jsonable converts string
void test_to_jsonable_string() {
  mixed result = to_jsonable("hello");
  if (result != "hello") {
    error("to_jsonable('hello') should return 'hello'\n");
  }
}

//! Test to_jsonable converts float
void test_to_jsonable_float() {
  mixed result = to_jsonable(3.14);
  if (result != 3.14) {
    error("to_jsonable(3.14) should return 3.14\n");
  }
}

//! Test to_jsonable converts array recursively
void test_to_jsonable_array() {
  mixed result = to_jsonable(({1, 2, 3}));
  if (!arrayp(result) || sizeof(result) != 3) {
    error("to_jsonable should preserve arrays\n");
  }
}

//! Test to_jsonable converts mapping recursively
void test_to_jsonable_mapping() {
  mixed result = to_jsonable((["key": "value"]));
  if (!mappingp(result) || result["key"] != "value") {
    error("to_jsonable should preserve mappings\n");
  }
}

//! Test json_describe returns string
void test_json_describe() {
  string json = json_describe(42);
  if (!stringp(json)) {
    error("json_describe should return a string\n");
  }
  // Should be valid JSON
  mixed parsed = Standards.JSON.decode(json);
  if (!mappingp(parsed)) {
    error("json_describe output should be valid JSON\n");
  }
}

//! Test json_environment returns string
void test_json_environment() {
  string json = json_environment();
  if (!stringp(json)) {
    error("json_environment should return a string\n");
  }
  // Should be valid JSON
  mixed parsed = Standards.JSON.decode(json);
  if (!mappingp(parsed)) {
    error("json_environment output should be valid JSON\n");
  }
}

//! Test json_search returns string
void test_json_search() {
  string json = json_search("read");
  if (!stringp(json)) {
    error("json_search should return a string\n");
  }
  // Should be valid JSON
  mixed parsed = Standards.JSON.decode(json);
  if (!mappingp(parsed)) {
    error("json_search output should be valid JSON\n");
  }
}

//! Test json_list_modules returns string
void test_json_list_modules() {
  string json = json_list_modules();
  if (!stringp(json)) {
    error("json_list_modules should return a string\n");
  }
  // Should be valid JSON
  mixed parsed = Standards.JSON.decode(json);
  if (!arrayp(parsed)) {
    error("json_list_modules output should be a JSON array\n");
  }
}

//! Test json_program returns string for valid program
void test_json_program() {
  string json = json_program("Stdio.FakeFile");
  if (!stringp(json)) {
    error("json_program should return a string for valid program\n");
  }
}

//! Test json_program returns UNDEFINED for invalid program
void test_json_program_invalid() {
  mixed json = json_program("NonExistent.Program");
  if (json != UNDEFINED) {
    error("json_program should return UNDEFINED for invalid program\n");
  }
}
