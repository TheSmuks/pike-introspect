// Introspect.pmod/Json.pmod
// JSON output formatters for LLM consumption

#pike __REAL_VERSION__

//! Functions for producing JSON output suitable for LLM consumption.
//!
//! This module provides functions to encode introspection results as JSON.
//! It uses direct function calls via master()->resolv() to avoid inheritance issues.

//! Convert any value to a JSON-encodable representation.
//!
//! @param val
//!   The value to convert.
//!
//! @returns
//!   A JSON-encodable value (string, int, float, array, mapping, or null).
mixed to_jsonable(mixed val) {
  if (undefinedp(val) || val == UNDEFINED)
    return UNDEFINED;  // JSON null
  if (intp(val) || floatp(val) || stringp(val))
    return val;
  if (arrayp(val))
    return map(val, to_jsonable);
  if (mappingp(val)) {
    mapping result = ([]);
    foreach(val; mixed k; mixed v) {
      if (stringp(k))
        result[k] = to_jsonable(v);
    }
    return result;
  }
  if (objectp(val))
    return sprintf("%O", val);
  if (functionp(val))
    return sprintf("%O", val);
  if (programp(val))
    return sprintf("%O", val);
  return sprintf("%O", val);
}

//! Get JSON description of any value.
//!
//! @param val
//!   The value to describe.
//!
//! @returns
//!   JSON-encoded description string.
string json_describe(mixed val) {
  // Get describe function from the parent Introspect module
  mixed introspect = master()->resolv("Introspect");
  if (!introspect) return UNDEFINED;
  function describe_fn = introspect->describe;
  if (!describe_fn) return UNDEFINED;
  
  mapping desc = describe_fn(val);
  return Standards.JSON.encode(to_jsonable(desc));
}

//! Get JSON representation of the Pike environment.
//!
//! @returns
//!   JSON-encoded environment summary.
string json_environment() {
  mixed introspect = master()->resolv("Introspect");
  if (!introspect) return UNDEFINED;
  function env_fn = introspect->environment_summary;
  if (!env_fn) return UNDEFINED;
  
  mapping env = env_fn();
  return Standards.JSON.encode(to_jsonable(env));
}

//! Get JSON search results.
//!
//! @param pattern
//!   Pattern to search for.
//!
//! @returns
//!   JSON-encoded search results.
string json_search(string pattern) {
  mixed introspect = master()->resolv("Introspect");
  if (!introspect) return UNDEFINED;
  function search_fn = introspect->search;
  if (!search_fn) return UNDEFINED;
  
  mapping results = search_fn(pattern);
  return Standards.JSON.encode(to_jsonable(results));
}

//! Get JSON description of a module.
//!
//! @param name
//!   Module name to describe.
//!
//! @returns
//!   JSON-encoded module description.
string json_module(string name) {
  mixed introspect = master()->resolv("Introspect");
  if (!introspect) return UNDEFINED;
  function desc_fn = introspect->describe_module_full;
  if (!desc_fn) return UNDEFINED;
  
  mapping desc = desc_fn(name);
  if (!desc) return UNDEFINED;
  return Standards.JSON.encode(to_jsonable(desc));
}

//! Get JSON description of a program.
//!
//! @param path
//!   Program path like "Stdio.File".
//!
//! @returns
//!   JSON-encoded program description, or UNDEFINED if not found.
string json_program(string path) {
  mixed introspect = master()->resolv("Introspect");
  if (!introspect) return UNDEFINED;
  
  function res_fn = introspect->resolve_program;
  function desc_fn = introspect->describe_program;
  if (!res_fn || !desc_fn) return UNDEFINED;
  
  program p = res_fn(path);
  if (!p) return UNDEFINED;
  
  mapping desc = desc_fn(p);
  return Standards.JSON.encode(to_jsonable(desc));
}

//! Get JSON list of available modules.
//!
//! @returns
//!   JSON-encoded array of module names.
string json_list_modules() {
  mixed introspect = master()->resolv("Introspect");
  if (!introspect) return UNDEFINED;
  function list_fn = introspect->list_modules;
  if (!list_fn) return UNDEFINED;
  
  array mods = list_fn();
  return Standards.JSON.encode(mods);
}

//! Get JSON description of a function.
//!
//! @param path
//!   Function path like "Stdio.read_file".
//!
//! @returns
//!   JSON-encoded function description, or UNDEFINED if not found.
string json_function(string path) {
  mixed introspect = master()->resolv("Introspect");
  if (!introspect) return UNDEFINED;
  
  function res_fn = introspect->resolve_function;
  function desc_fn = introspect->describe_function;
  if (!res_fn || !desc_fn) return UNDEFINED;
  
  function f = res_fn(path);
  if (!f) return UNDEFINED;
  
  mapping desc = desc_fn(f);
  return Standards.JSON.encode(to_jsonable(desc));
}
