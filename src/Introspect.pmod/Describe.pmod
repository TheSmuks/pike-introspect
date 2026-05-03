// Introspect.pmod/Describe.pmod
// Symbol description functions

#pike __REAL_VERSION__

//! Parse a source location string from Program.defined() or Function.defined().
//!
//! @param def
//!   Definition string like "/path/to/file.pike:42" or just "/path/to/file.pike"
//!
//! @returns
//!   Mapping with "source_file" and optionally "source_line"
private mapping _parse_source_location(string def) {
  if (!def || def == "")
    return (["source_file": UNDEFINED]);

  string file;
  int line;
  if (sscanf(def, "%s:%d", file, line) == 2) {
    return (["source_file": file, "source_line": line]);
  }
  return (["source_file": def]);
}

//! Functions for describing symbols in detail.

//! Get a type string for any value.
//!
//! @param val
//!   The value to get the type of.
//!
//! @returns
//!   Type string like "int", "string", "function", etc.
string get_type(mixed val) {
  return sprintf("%t", val);
}

//! Universal describe function that dispatches based on type.
//!
//! @param val
//!   The value to describe.
//!
//! @returns
//!   Mapping with type-specific description.
mapping describe(mixed val) {
  if (functionp(val))
    return describe_function(val);
  if (programp(val))
    return describe_program(val);
  if (objectp(val))
    return describe_object(val);
  if (arrayp(val))
    return describe_array(val);
  if (mappingp(val))
    return describe_mapping(val);
  if (stringp(val))
    return describe_string(val);
  if (intp(val))
    return describe_int(val);
  if (floatp(val))
    return describe_float(val);

  return ([ "type": get_type(val), "value": val ]);
}

//! Describe an array.
//!
//! @param arr
//!   The array to describe.
//!
//! @returns
//!   Mapping with array information.
mapping describe_array(array arr) {
  return ([ 
    "type": "array",
    "length": sizeof(arr),
    "element_type": sizeof(arr) > 0 ? get_type(arr[0]) : "empty"
  ]);
}

//! Describe a mapping.
//!
//! @param m
//!   The mapping to describe.
//!
//! @returns
//!   Mapping with mapping information.
mapping describe_mapping(mapping m) {
  return ([ 
    "type": "mapping",
    "size": sizeof(m)
  ]);
}

//! Describe a string.
//!
//! @param s
//!   The string to describe.
//!
//! @returns
//!   Mapping with string information.
mapping describe_string(string s) {
  return ([ 
    "type": "string",
    "length": sizeof(s),
    "empty": sizeof(s) == 0,
    "multiline": has_value(s, "\n")
  ]);
}

//! Describe an integer.
//!
//! @param i
//!   The integer to describe.
//!
//! @returns
//!   Mapping with integer information.
mapping describe_int(int i) {
  return ([ 
    "type": "int",
    "value": i,
    "negative": i < 0,
    "zero": i == 0
  ]);
}

//! Describe a float.
//!
//! @param f
//!   The float to describe.
//!
//! @returns
//!   Mapping with float information.
mapping describe_float(float f) {
  return ([ 
    "type": "float",
    "value": f,
    "nan": f != f,  // NaN check
    "infinite": f == Math.inf || f == -Math.inf
  ]);
}

//! Describe a program (class) in detail.
//!
//! @param p
//!   The program to describe.
//!
//! @returns
//!   Mapping with program information including source location and inheritance.
mapping describe_program(program p) {
  string name = sprintf("%O", p);

  // Get source location
  string source_def;
  catch { source_def = Program.defined(p); };
  mapping source_loc = _parse_source_location(source_def || "");

  array(mapping) methods = ({});
  array(mapping) constants = ({});
  array(mapping) inherits = ({});
  array(string) inherited_methods = ({});
  array(string) inherited_constants = ({});

  // Collect our own method names for filtering inherited methods later
  array(string) own_methods = ({});
  array(string) own_constants = ({});

  // Try to enumerate members by creating an instance
  object inst = UNDEFINED;
  catch { inst = p(); };

  if (inst) {
    array idx = ({});
    catch { idx = indices(inst); };

    foreach(idx, string sym) {
      mixed v;
      catch { v = inst[sym]; };
      if (callablep(v)) {
        // Get method source location
        string method_def;
        catch { method_def = Function.defined(v); };
        mapping method_loc = _parse_source_location(method_def || "");
        methods += ({ (["name": sym]) + method_loc });
        own_methods += ({ sym });
      } else if (!functionp(v) && !programp(v) && !objectp(v)) {
        // Get constant source location
        string const_def;
        catch { const_def = Program.defined(p, sym); };
        mapping const_loc = _parse_source_location(const_def || "");
        constants += ({ (["name": sym]) + const_loc });
        own_constants += ({ sym });
      }
    }

    destruct(inst);
  }

  // Collect inheritance information
  array parent_progs = ({});
  catch { parent_progs = Program.inherit_list(p); };

  foreach(parent_progs, mixed parent_info) {
    program parent_prog;
    string parent_name;

    if (mappingp(parent_info)) {
      parent_prog = parent_info["program"];
      parent_name = parent_info["name"] || sprintf("%O", parent_prog);
    } else if (programp(parent_info)) {
      parent_prog = parent_info;
      parent_name = sprintf("%O", parent_prog);
    }

    if (!parent_prog) continue;

    // Get parent source location
    string parent_def;
    catch { parent_def = Program.defined(parent_prog); };
    mapping parent_loc = _parse_source_location(parent_def || "");

    inherits += ({ (["name": parent_name]) + parent_loc });

    // Get inherited methods and constants from parent
    object parent_inst = UNDEFINED;
    catch { parent_inst = parent_prog(); };

    if (parent_inst) {
      array parent_idx = ({});
      catch { parent_idx = indices(parent_inst); };

      foreach(parent_idx, string sym) {
        mixed v;
        catch { v = parent_inst[sym]; };
        if (callablep(v) && !has_value(own_methods, sym)) {
          inherited_methods |= ({ sym });
        } else if (!functionp(v) && !programp(v) && !objectp(v) && !has_value(own_constants, sym)) {
          inherited_constants |= ({ sym });
        }
      }

      destruct(parent_inst);
    }
  }

  // Sort methods and constants by name (extract names, sort, rebuild)
  array(string) method_names = sort(map(methods, lambda(mapping m) { return m["name"]; }));
  array(mapping) sorted_methods = ({});
  foreach(method_names, string n) {
    foreach(methods, mapping m) {
      if (m["name"] == n) {
        sorted_methods += ({ m });
        break;
      }
    }
  }

  array(string) const_names = sort(map(constants, lambda(mapping m) { return m["name"]; }));
  array(mapping) sorted_constants = ({});
  foreach(const_names, string n) {
    foreach(constants, mapping m) {
      if (m["name"] == n) {
        sorted_constants += ({ m });
        break;
      }
    }
  }

  // Build the result mapping
  mapping result = ([ 
    "name": name,
    "type": "program",
    "methods": sorted_methods,
    "constants": sorted_constants
  ]);

  // Add source location if available
  if (source_loc["source_file"])
    result["source_file"] = source_loc["source_file"];
  if (source_loc["source_line"])
    result["source_line"] = source_loc["source_line"];

  // Add inheritance information
  if (sizeof(inherits) > 0) {
    array(string) inherit_names = sort(map(inherits, lambda(mapping m) { return m["name"]; }));
    array(mapping) sorted_inherits = ({});
    foreach(inherit_names, string n) {
      foreach(inherits, mapping m) {
        if (m["name"] == n) {
          sorted_inherits += ({ m });
          break;
        }
      }
    }
    result["inherits"] = sorted_inherits;
  }
  if (sizeof(inherited_methods) > 0)
    result["inherited_methods"] = sort(inherited_methods);
  if (sizeof(inherited_constants) > 0)
    result["inherited_constants"] = sort(inherited_constants);

  return result;
}

//! Describe a function in detail.
//!
//! @param f
//!   The function to describe.
//!
//! @returns
//!   Mapping with function information including source location.
mapping describe_function(function f) {
  string name = sprintf("%O", f);

  // Get source location
  string source_def;
  catch { source_def = Function.defined(f); };
  mapping source_loc = _parse_source_location(source_def || "");

  mapping result = ([ 
    "name": name,
    "type": "function",
    "signature": name
  ]);

  // Add source location if available
  if (source_loc["source_file"])
    result["source_file"] = source_loc["source_file"];
  if (source_loc["source_line"])
    result["source_line"] = source_loc["source_line"];

  return result;
}

//! Describe an object in detail.
//!
//! @param o
//!   The object to describe.
//!
//! @returns
//!   Mapping with object information including source location.
mapping describe_object(object o) {
  program p = object_program(o);
  array(string) methods = ({});
  array(string) variables = ({});

  // Get source location from the program
  string source_def;
  catch { source_def = Program.defined(p); };
  mapping source_loc = _parse_source_location(source_def || "");

  array idx = ({});
  catch { idx = indices(o); };

  foreach(idx, string sym) {
    mixed v;
    catch { v = o[sym]; };
    if (callablep(v)) {
      methods += ({ sym });
    } else {
      variables += ({ sym });
    }
  }

  mapping result = ([ 
    "program": sprintf("%O", p),
    "type": "object",
    "methods": sort(methods),
    "variables": sort(variables)
  ]);

  // Add source location if available
  if (source_loc["source_file"])
    result["source_file"] = source_loc["source_file"];
  if (source_loc["source_line"])
    result["source_line"] = source_loc["source_line"];

  return result;
}

//! Describe a module in full detail.
//!
//! @param name
//!   The module name to describe.
//!
//! @returns
//!   Mapping with complete module information.
mapping describe_module_full(string name) {
  mixed mod = master()->resolv(name);
  if (!mod) return UNDEFINED;

  array(string) programs = ({});
  array(string) functions = ({});
  array(string) constants = ({});
  array(string) objects = ({});

  array idx = ({});
  catch { idx = indices(mod); };

  foreach(idx, string sym) {
    mixed val;
    catch { val = mod[sym]; };
    if (undefinedp(val)) continue;

    if (programp(val)) {
      programs += ({ sym });
    } else if (functionp(val) || callablep(val)) {
      functions += ({ sym });
    } else if (objectp(val)) {
      objects += ({ sym });
    } else {
      constants += ({ sym });
    }
  }

  return ([ 
    "name": name,
    "type": "module",
    "programs": sort(programs),
    "functions": sort(functions),
    "objects": sort(objects),
    "constants": sort(constants),
    "total_symbols": sizeof(idx)
  ]);
}

//! Get a summary of the Pike environment.
//!
//! @returns
//!   Mapping with environment information.
mapping environment_summary() {
  array(string) modules = ({});

  // Get stdlib modules
  constant STD_LIBS = (<
    "Stdio", "Standards", "Protocols", "Math", "Thread", "Crypto",
    "Image", "GTK2", "GL", "SQL", "Calendar", "Tools", "Val", "Gmp",
    "Parser", "ADT", "Concurrent", "Sql"
  >);

  foreach(sort(indices(STD_LIBS)), string name) {
    if (!catch(master()->resolv(name)))
      modules += ({ name });
  }

  mapping constants = all_constants();

  // __VERSION__ is a float like 8.0.1116, convert to string
  string ver = sprintf("%.3g", __VERSION__);

  return ([ 
    "pike_version": ver,
    "module_count": sizeof(modules),
    "modules": sort(modules),
    "stdlib_modules": sort(indices(STD_LIBS)),
    "constant_count": sizeof(constants)
  ]);
}

//! Get the Pike version as a string.
//!
//! @returns
//!   Pike version string.
string pike_version() {
  return sprintf("%.3g", __VERSION__);
}