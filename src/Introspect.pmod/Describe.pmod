// Introspect.pmod/Describe.pmod
// Symbol description functions

#pike __REAL_VERSION__

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
    "size": sizeof(m),
    "key_types": ({}),
    "value_types": ({})
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
//!   Mapping with program information.
mapping describe_program(program p) {
  string name = sprintf("%O", p);
  array(string) methods = ({});
  array(string) constants = ({});
  array(string) inherits = ({});

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
        methods += ({ sym });
      } else if (!functionp(v) && !programp(v) && !objectp(v)) {
        constants += ({ sym });
      }
    }

    destruct(inst);
  }

  return ([ 
    "name": name,
    "type": "program",
    "methods": sort(methods),
    "constants": sort(constants),
    "inherits": sort(inherits),
    "program_identifier": UNDEFINED
  ]);
}

//! Describe a function in detail.
//!
//! @param f
//!   The function to describe.
//!
//! @returns
//!   Mapping with function information.
mapping describe_function(function f) {
  string name = sprintf("%O", f);

  return ([ 
    "name": name,
    "type": "function",
    "signature": name,  // %O already gives a good signature
    "module": UNDEFINED
  ]);
}

//! Describe an object in detail.
//!
//! @param o
//!   The object to describe.
//!
//! @returns
//!   Mapping with object information.
mapping describe_object(object o) {
  program p = object_program(o);
  array(string) methods = ({});
  array(string) constants = ({});
  array(string) variables = ({});

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

  return ([ 
    "program": sprintf("%O", p),
    "program_name": sprintf("%O", p),
    "type": "object",
    "methods": sort(methods),
    "variables": sort(variables),
    "constants": sort(constants)
  ]);
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
  array(string) submodules = ({});
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
    "submodules": sort(submodules),
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

  return ([ 
    "pike_version": __VERSION__,
    "pike_version_major": __VERSION_MAJOR__,
    "pike_version_minor": __VERSION_MINOR__,
    "pike_version_patch": __VERSION_PATCH__,
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
  return __VERSION__;
}
