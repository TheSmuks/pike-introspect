# Pike Runtime Discovery Guide

A comprehensive guide to Pike's built-in introspection capabilities.

## Overview

Pike provides several built-in mechanisms for runtime introspection:

1. **Enumeration** - `indices()` and `values()` to list symbols
2. **Type Predicates** - Functions like `functionp()`, `programp()` to check types
3. **Type Information** - `sprintf("%t")` and `sprintf("%O")` for type details
4. **Global Constants** - `all_constants()` for the global namespace
5. **Path Resolution** - `master()->resolv()` to resolve qualified names
6. **Backtraces** - `backtrace()` and `describe_backtrace()` for stack traces

---

## Enumeration

### `indices()` and `values()`

```pike
// Get symbol names from an object/program
array idx = indices(my_object);    // Symbol names
array vals = values(my_object);    // Symbol values

// Example with Stdio module
array symbols = indices(Stdio);
// ({ "read_file", "FILE", "FakeFile", "stdin", ... })
```

**Note:** For programs, you may need to instantiate them first to enumerate members:

```pike
// For programs, create an instance
object inst = my_program();
array methods = indices(inst);
destruct(inst);
```

---

## Type Predicates

Use these functions to check the type of a value:

```pike
functionp(val)      // Is it a function?
programp(val)       // Is it a program (class)?
objectp(val)         // Is it an object?
stringp(val)         // Is it a string?
intp(val)           // Is it an integer?
floatp(val)         // Is it a float?
arrayp(val)         // Is it an array?
mappingp(val)       // Is it a mapping?
multisetp(val)      // Is it a multiset?
callablep(val)      // Is it callable (function or object with `()`)?
undefinedp(val)     // Is it UNDEFINED?
```

**Example:**

```pike
if (functionp(my_val)) {
    // It's a function, call it
    result = my_val(arg1, arg2);
} else if (programp(my_val)) {
    // It's a program, instantiate it
    object inst = my_val();
}
```

---

## Type Information

### `sprintf("%t", value)` - Type Name

```pike
// Get the type name as a string
sprintf("%t", 42);           // "int"
sprintf("%t", "hello");     // "string"
sprintf("%t", ({1,2}));     // "array"
sprintf("%t", my_func);    // "function"
sprintf("%t", MyClass);     // "program"
```

### `sprintf("%O", value)` - Object Description

```pike
// Get a descriptive string representation
sprintf("%O", Stdio.read_file);  // "Stdio.read_file"
sprintf("%O", Stdio.FILE);       // "Stdio.FILE"
sprintf("%O", my_object);         // Object description
```

---

## Global Constants

### `all_constants()`

Returns the global constants table as a mapping:

```pike
mapping c = all_constants();
// ({ "Stdio": Stdio, "Standards": Standards, "true": 1, ... })

array names = indices(c);
array values = values(c);

// Check if a constant exists
if (has_index(c, "Stdio")) {
    // Stdio exists
}

// Find all functions
array fn_consts = filter(indices(c), lambda(string n) {
    return functionp(c[n]);
});
```

---

## Path Resolution

### `master()->resolv(string path)`

Resolve a qualified symbol path to its value:

```pike
// Resolve a module
mixed stdio = master()->resolv("Stdio");

// Resolve a function
function rf = master()->resolv("Stdio.read_file");

// Resolve a program
program file_class = master()->resolv("Stdio.FILE");

// Resolve nested paths
mixed query = master()->resolv("Protocols.HTTP.Server.Query");
```

**Error Handling:**

```pike
mixed val = master()->resolv("SomeModule");
if (!val) {
    // Module not found
}

// Or use catch
mixed err = catch {
    return master()->resolv("NonExistent.Module");
};
if (err) {
    // Resolution failed
}
```

---

## Backtraces

### `backtrace()`

Get the current call stack:

```pike
array bt = backtrace();
// Each frame is: ({ file, line, function, args... })
```

### `describe_backtrace(array bt)`

Get a human-readable backtrace:

```pike
string trace = describe_backtrace(backtrace());
write("%s\n", trace);
```

---

## Object Programs

### `object_program(object o)`

Get the program (class) that an object is an instance of:

```pike
Stdio.File f = Stdio.FILE();
program p = object_program(f);
// p is Stdio.FILE or a subclass
destruct(f);
```

---

## Compile-Time Introspection

### `compile_string(string code)`

Compile Pike code from a string (useful for probing):

```pike
program p = compile_string("int test() { return 42; }");
int result = p->test();  // 42
```

---

## Common Patterns

### Pattern: Find All Functions in a Module

```pike
array find_functions(mixed mod) {
    array functions = ({});
    array idx = indices(mod);
    foreach(idx, string name) {
        mixed val = mod[name];
        if (functionp(val)) {
            functions += ({ name });
        }
    }
    return sort(functions);
}

// Usage
array fns = find_functions(Stdio);
// ({ "append_path_unix", "append_path", "cp", "file_size", ... })
```

### Pattern: Find All Programs in a Module

```pike
array find_programs(mixed mod) {
    array programs = ({});
    array idx = indices(mod);
    foreach(idx, string name) {
        mixed val = mod[name];
        if (programp(val)) {
            programs += ({ name });
        }
    }
    return sort(programs);
}

// Usage
array progs = find_programs(Stdio);
// ({ "FakeFile", "Buffer", "File", "Stat", ... })
```

### Pattern: Describe an Object's Interface

```pike
mapping describe_object(object o) {
    array idx = indices(o);
    array methods = ({});
    array vars = ({});
    
    foreach(idx, string name) {
        mixed v = o[name];
        if (callablep(v)) {
            methods += ({ name });
        } else {
            vars += ({ name });
        }
    }
    
    return ([ 
        "program": sprintf("%O", object_program(o)),
        "methods": sort(methods),
        "variables": sort(vars)
    ]);
}
```

### Pattern: Search by Pattern

```pike
array search_by_pattern(array items, string pattern) {
    string pat = lower_case(pattern);
    return filter(items, lambda(string s) {
        return has_value(lower_case(s), pat);
    });
}

// Usage
array files = search_by_pattern(indices(Stdio), "file");
// ({ "FakeFile", "file_size", ... })
```

---

## Limitations

### Private Symbols

Pike does not expose private symbols (those starting with `_` or marked private) through normal introspection.

### Program Members

For programs (classes) that cannot be instantiated (e.g., abstract classes), you may not be able to enumerate their members without special handling.

### Native Modules

Some Pike modules are implemented in C (native .so files). These may have limited introspectability compared to pure-Pike modules.

---

## See Also

- [Introspection API Reference](introspection-api.md) - The Introspect module API
- Pike documentation: `doc://refman/Builtin`
