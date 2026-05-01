// Introspect.pmod/Search.pmod
// Pattern-based search across all symbols

#pike __REAL_VERSION__

//! Functions for searching symbols by pattern.

constant STD_LIBS = (<
  "Stdio", "Standards", "Protocols", "Math", "Thread", "Crypto",
  "Image", "GTK2", "GL", "SQL", "Calendar", "Tools", "Val", "Gmp",
  "Parser", "ADT", "Concurrent", "Sql"
>);

//! Search all symbols matching a pattern.
//!
//! @param pattern
//!   Case-insensitive substring pattern to search for.
//!
//! @returns
//!   Mapping with arrays of matching modules, programs, and functions.
mapping search_symbols(string pattern) {
  return ([ 
    "modules": search_modules(pattern),
    "programs": search_programs(pattern),
    "functions": search_functions(pattern),
    "pattern": pattern
  ]);
}

//! Search for modules matching a pattern.
//!
//! @param pattern
//!   Case-insensitive substring pattern to search for.
//!
//! @returns
//!   Array of matching module names.
array(string) search_modules(string pattern) {
  array(string) results = ({});
  string pat = lower_case(pattern);

  // Search stdlib module names
  foreach(sort(indices(STD_LIBS)), string name) {
    if (has_value(lower_case(name), pat))
      results += ({ name });
  }

  return results;
}

//! Search for programs matching a pattern.
//!
//! @param pattern
//!   Case-insensitive substring pattern to search for.
//!
//! @returns
//!   Array of matching program paths.
array(string) search_programs(string pattern) {
  array(string) results = ({});
  string pat = lower_case(pattern);

  // Search through known modules
  foreach(sort(indices(STD_LIBS)), string modname) {
    mixed mod = master()->resolv(modname);
    if (!mod) continue;

    array idx = ({});
    catch { idx = indices(mod); };

    foreach(idx, string sym) {
      mixed val;
      catch { val = mod[sym]; };
      if (programp(val) && has_value(lower_case(sym), pat)) {
        results += ({ modname + "." + sym });
      }
    }
  }

  return results;
}

//! Search for functions matching a pattern.
//!
//! @param pattern
//!   Case-insensitive substring pattern to search for.
//!
//! @returns
//!   Array of matching function paths.
array(string) search_functions(string pattern) {
  array(string) results = ({});
  string pat = lower_case(pattern);

  // Search through known modules
  foreach(sort(indices(STD_LIBS)), string modname) {
    mixed mod = master()->resolv(modname);
    if (!mod) continue;

    array idx = ({});
    catch { idx = indices(mod); };

    foreach(idx, string sym) {
      mixed val;
      catch { val = mod[sym]; };
      if (functionp(val) && has_value(lower_case(sym), pat)) {
        results += ({ modname + "." + sym });
      }
    }
  }

  // Also search global constants
  mapping c = all_constants();
  foreach(indices(c), string name) {
    mixed v = c[name];
    if (functionp(v) && has_value(lower_case(name), pat)) {
      if (!has_value(results, name))
        results += ({ name });
    }
  }

  return sort(results);
}

//! Search for constants matching a pattern.
//!
//! @param pattern
//!   Case-insensitive substring pattern to search for.
//!
//! @returns
//!   Array of matching constant names.
array(string) search_constants(string pattern) {
  array(string) results = ({});
  string pat = lower_case(pattern);

  mapping c = all_constants();
  foreach(indices(c), string name) {
    mixed v = c[name];
    if (!functionp(v) && !programp(v) && !objectp(v)) {
      if (has_value(lower_case(name), pat))
        results += ({ name });
    }
  }

  return sort(results);
}
