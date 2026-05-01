// Introspect.pmod/Json.pmod
// JSON output formatters for LLM consumption

#pike __REAL_VERSION__

//! Functions for producing JSON output suitable for LLM consumption.

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
  // Use the inherited describe from Describe
  mapping desc = ::describe(val);
  mixed jsonable = to_jsonable(desc);
  return Standards.JSON.encode(jsonable);
}

//! Get JSON representation of the Pike environment.
//!
//! @returns
//!   JSON-encoded environment summary.
string json_environment() {
  // Use the inherited environment_summary from Describe
  mapping env = ::environment_summary();
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
  // Use the inherited search from Search  
  mapping results = ::search(pattern);
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
  mapping desc = ::describe_module_full(name);
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
  program|void p = ::resolve_program(path);
  if (!p) return UNDEFINED;
  mapping desc = ::describe_program(p);
  return Standards.JSON.encode(to_jsonable(desc));
}

//! Get JSON list of available modules.
//!
//! @returns
//!   JSON-encoded array of module names.
string json_list_modules() {
  array mods = ::list_modules();
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
  function|void f = ::resolve_function(path);
  if (!f) return UNDEFINED;
  mapping desc = ::describe_function(f);
  return Standards.JSON.encode(to_jsonable(desc));
}
