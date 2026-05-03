// Introspect.pmod/Discover.pmod
// Module, program, function, and constant discovery

#pike __REAL_VERSION__

//! Functions for discovering modules, programs, functions, and constants
//! in the Pike runtime environment.

// Known stdlib module names
constant STD_LIBS = (<
  "Stdio",
  "Standards",
  "Protocols",
  "Math",
  "Thread",
  "Crypto",
  "Image",
  "GTK2",
  "GL",
  "GLU",
  "GLUT",
  "SQL",
  "Curl",
  "Git",
  "MIME",
  "Calendar",
  "Geography",
  "Tools",
  "Val",
  "Gmp",
  "Bzip2",
  "Zlib",
  "Exif",
  "Cbor",
  "YAML",
  "Parser",
  "Process",
  "System",
  "Sql",
  "Regexp",
  "Locale",
  "Function",
  "ADT",
  "Concurrent",
  "Debugger",
  "Profiler",
  "Web",
  "Filesystem"
>);

// Cache for list_modules results
array(string) cached_modules = ({});
int cache_valid = 0;

//! List all importable modules in the current Pike environment.
//!
//! @returns
//!   Array of module names that can be imported.
array(string) list_modules() {
  if (cache_valid && sizeof(cached_modules) > 0)
    return cached_modules;

  array(string) modules = ({});

  // Add stdlib modules that can be resolved
  foreach(sort(indices(STD_LIBS)), string name) {
    if (!catch(master()->resolv(name)))
      modules += ({ name });
  }

  // Try to find modules from all_constants
  mapping c = all_constants();
  foreach(indices(c), string k) {
    // Look for module-like constants (objects with callable members)
    mixed v = c[k];
    if (objectp(v) && k != "master" && k != "prevailing" && k != "this") {
      // Check if it looks like a module
      array syms = ({});
      catch { syms = indices(v); };
      if (sizeof(syms) > 3 && !has_value(k, "-")) {
        modules |= ({ k });
      }
    }
  }

  cached_modules = sort(modules);
  cache_valid = 1;
  return cached_modules;
}

//! List known stdlib module names.
//!
//! @returns
//!   Array of known stdlib module names.
array(string) list_stdlib_modules() {
  return sort(indices(STD_LIBS));
}

//! Get a description of a module including its programs, functions, etc.
//!
//! @param name
//!   The module name to describe.
//!
//! @returns
//!   Mapping with module information, or UNDEFINED if not found.
mapping describe_module(string name) {
  mixed mod = master()->resolv(name);
  if (!mod) return UNDEFINED;

  array(string) programs = ({});
  array(string) functions = ({});
  array(string) constants = ({});
  array(string) submodules = ({});

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
    } else if (!functionp(val) && !programp(val) && !objectp(val)) {
      // Only add if it is a simple constant
      constants += ({ sym });
    }
  }

  return ([ 
    "name": name,
    "programs": sort(programs),
    "functions": sort(functions),
    "constants": sort(constants),
    "submodules": sort(submodules),
    "path": UNDEFINED,
    "is_stdlib": STD_LIBS[name] ? 1 : 0
  ]);
}

//! List all program-valued symbols in a module or object.
//!
//! @param mod
//!   The module or object to inspect.
//!
//! @returns
//!   Array of program symbol names.
array(string) list_programs(object|program mod) {
  if (!mod) return ({});

  array(string) programs = ({});
  array idx = ({});

  catch { idx = indices(mod); };

  foreach(idx, string sym) {
    mixed val;
    catch { val = mod[sym]; };
    if (programp(val)) {
      programs += ({ sym });
    }
  }

  return sort(programs);
}

//! Resolve a qualified program path.
//!
//! @param path
//!   Program path like "Stdio.File" or "Protocols.HTTP.Query"
//!
//! @returns
//!   The resolved program, or UNDEFINED if not found.
program|void resolve_program(string path) {
  mixed val = master()->resolv(path);
  if (programp(val)) return val;
  return UNDEFINED;
}

//! List all function-valued symbols in a module or object.
//!
//! @param mod
//!   The module or object to inspect.
//!
//! @returns
//!   Array of function symbol names.
array(string) list_functions(object|program mod) {
  if (!mod) return ({});

  array(string) functions = ({});
  array idx = ({});

  catch { idx = indices(mod); };

  foreach(idx, string sym) {
    mixed val;
    catch { val = mod[sym]; };
    if (functionp(val)) {
      functions += ({ sym });
    }
  }

  return sort(functions);
}

//! Resolve a qualified function path.
//!
//! @param path
//!   Function path like "Stdio.read_file"
//!
//! @returns
//!   The resolved function, or UNDEFINED if not found.
function|void resolve_function(string path) {
  mixed val = master()->resolv(path);
  if (functionp(val)) return val;
  return UNDEFINED;
}

//! List non-function, non-program public symbols in a module.
//!
//! @param mod
//!   The module or object to inspect.
//!
//! @returns
//!   Array of constant symbol names.
array(string) list_constants(object|program mod) {
  if (!mod) return ({});

  array(string) constants = ({});
  array idx = ({});

  catch { idx = indices(mod); };

  foreach(idx, string sym) {
    mixed val;
    catch { val = mod[sym]; };
    // Exclude functions, programs, and nested objects
    if (!functionp(val) && !programp(val) && !objectp(val)) {
      constants += ({ sym });
    }
  }

  return sort(constants);
}

//! Get a mapping of constant names to values.
//!
//! @param mod
//!   The module or object to inspect.
//!
//! @returns
//!   Mapping of constant name to value.
mapping(string:mixed) get_constants_map(object|program mod) {
  if (!mod) return ([]);

  mapping(string:mixed) result = ([]);
  array idx = ({});

  catch { idx = indices(mod); };

  foreach(idx, string sym) {
    mixed val;
    catch { val = mod[sym]; };
    if (!functionp(val) && !programp(val) && !objectp(val)) {
      result[sym] = val;
    }
  }

  return result;
}

//! Resolve a qualified symbol path and return detailed information about it.
//!
//! @param name
//!   Qualified symbol path like "Stdio.FakeFile", "Stdio.read_file", or "Stdio"
//!
//! @returns
//!   Mapping with symbol information (name, kind, source_location), or UNDEFINED if not found.
mapping resolve_symbol(string name) {
  mixed val;
  catch { val = master()->resolv(name); };
  
  if (undefinedp(val) || !val)
    return UNDEFINED;

  string kind;
  if (programp(val)) {
    kind = "class";
  } else if (functionp(val)) {
    kind = "function";
  } else if (objectp(val)) {
    kind = "module";
  } else {
    kind = "variable";
  }

  mapping result = (["name": name, "kind": kind]);

  // Source location for programs
  if (programp(val)) {
    string def;
    catch { def = Program.defined(val); };
    if (def && def != "") {
      string file;
      int line;
      if (sscanf(def, "%s:%d", file, line) == 2) {
        result["source_file"] = file;
        result["source_line"] = line;
      } else {
        result["source_file"] = def;
      }
    }
    result["program"] = val;
  }
  // Source location for functions
  else if (functionp(val)) {
    string def;
    catch { def = Function.defined(val); };
    if (def && def != "") {
      string file;
      int line;
      if (sscanf(def, "%s:%d", file, line) == 2) {
        result["source_file"] = file;
        result["source_line"] = line;
      } else {
        result["source_file"] = def;
      }
    }
  }
  // For modules (objects), get program location
  else if (objectp(val)) {
    program p = object_program(val);
    if (p) {
      string def;
      catch { def = Program.defined(p); };
      if (def && def != "") {
        result["source_file"] = def;
      }
      result["program"] = p;
    }
  }
  // For variables/constants, try to find definition in a known program
  else {
    // Try to find which program defines this constant
    // Split name and try to resolve the parent program
    array parts = name / ".";
    if (sizeof(parts) > 1) {
      string parent_path = parts[..<1] * ".";
      mixed parent;
      catch { parent = master()->resolv(parent_path); };
      if (programp(parent)) {
        string member = parts[-1];
        string def;
        catch { def = Program.defined(parent, member); };
        if (def && def != "") {
          string file;
          int line;
          if (sscanf(def, "%s:%d", file, line) == 2) {
            result["source_file"] = file;
            result["source_line"] = line;
          } else {
            result["source_file"] = def;
          }
        }
      }
    }
  }

  return result;
}
