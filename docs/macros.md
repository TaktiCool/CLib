# Macros

Comprehensive reference for all CLib preprocessor macros for variable namespacing, function calling, logging, UI positioning, and module configuration.

## Version & Configuration Macros

### Version Information

| Macro | Description |
|-------|-------------|
| `PREFIX` | Addon prefix ("CLib") |
| `PATH` | Path prefix ("tc") |
| `MOD` | Mod name ("CLib") |
| `MAJOR` | Major version number (0) |
| `MINOR` | Minor version number (15) |
| `PATCHLVL` | Patch level (0) |
| `BUILD` | Build number (1117) |
| `VERSION` | Complete version string `MAJOR.MINOR.PATCHLVL.BUILD` |
| `VERSION_AR` | Version as array `[MAJOR, MINOR, PATCHLVL, BUILD]` |

### Debug & Development Settings

Enable/disable debug features via preprocessor defines:

```sqf
#define DEBUGFULL        // Enable all debug methods (logging, performance counter, function tracing)
#define ISDEV            // Enable improved logging
#define ENABLEPERFORMANCECOUNTER  // Measure function execution time
#define ENABLEFUNCTIONTRACE       // Log function calls with parameters
#define DISABLECOMPRESSION        // Disable string compression
```

Command-line overrides:
- `-preprocDefine=CLIB_ISDEV`
- `-preprocDefine=CLIB_DISABLECOMPRESSION`

## Variable Namespace Macros

### Basic Namespacing

| Macro | Usage | Result |
|-------|-------|--------|
| `DOUBLE(var1,var2)` | `DOUBLE(foo,bar)` | `foo_bar` |
| `TRIPLE(var1,var2,var3)` | `TRIPLE(a,b,c)` | `a_b_c` |
| `QUOTE(var)` | `QUOTE(myVar)` | `"myVar"` |

### Global & Module Variables

| Macro | Purpose |
|-------|---------|
| `EGVAR(var1,var2)` | Extended global variable: `CLib_var1_var2` |
| `QEGVAR(var1,var2)` | Quoted EGVAR: `"CLib_var1_var2"` |
| `GVAR(var)` | Module global variable: `CLib_MODULE_var` |
| `QGVAR(var)` | Quoted GVAR: `"CLib_MODULE_var"` |
| `CGVAR(var)` | CLib global variable: `CLib_var` |
| `QCGVAR(var)` | Quoted CGVAR: `"CLib_var"` |
| `UIVAR(var1)` | UI namespace variable: `"CLib_UI_var1"` |

## Function Macros

### Function References

| Macro | Purpose | Example |
|-------|---------|---------|
| `EDFUNC(var1,var2)` | Extended default function: `CLib_var1_fnc_var2` | `EDFUNC(PerFrame,wait)` → `CLib_PerFrame_fnc_wait` |
| `DFUNC(var)` | Module function: `CLib_MODULE_fnc_var` | `DFUNC(testFunc)` → `CLib_PerFrame_fnc_testFunc` |
| `QEFUNC(var1,var2)` | Quoted EDFUNC | `QEFUNC(Core,log)` → `"CLib_Core_fnc_log"` |
| `QFUNC(var)` | Quoted DFUNC | `QFUNC(init)` → `"CLib_MODULE_fnc_init"` |
| `EFUNC(var1,var2)` | Call extended function with error checking | `EFUNC(PerFrame,wait)` |
| `FUNC(var)` | Call module function with error checking | `FUNC(init)` |
| `CFUNC(var)` | Call CLib function with error checking | `CFUNC(log)` |
| `DCFUNC(var)` | Direct CLib function reference | `DCFUNC(log)` → `CLib_fnc_log` |
| `QCFUNC(var)` | Quoted DCFUNC | `QCFUNC(log)` → `"CLib_fnc_log"` |

In `ISDEV` mode, `EFUNC` and `CFUNC` include error checking and will log missing functions.

## Logging Macros

| Macro | Level | Condition | Usage |
|-------|-------|-----------|-------|
| `DUMP(var)` | DEBUG | ISDEV only | `DUMP("Variable: " + str _myVar)` |
| `LOG(var)` | INFO | Always | `LOG("Function executed")` |
| `ERROR_LOG(var)` | ERROR | Always | `ERROR_LOG("Invalid parameter")` |

These macros use `SYSLOGGING` internally and include:
- Frame number
- Module name
- Custom message
- File and line number
- Script context (when available)

## Data Type Check Macros

Check variable types for safer conditional logic:

| Macro | Checks For | Usage |
|-------|-----------|-------|
| `IS_ARRAY(var)` | Array `[]` | `if (IS_ARRAY(data)) then {...}` |
| `IS_BOOL(var)` | Boolean `true`/`false` | `if (IS_BOOL(flag)) then {...}` |
| `IS_CODE(var)` | Code `{}` | `if (IS_CODE(callback)) then {...}` |
| `IS_CONFIG(var)` | Config path | `if (IS_CONFIG(cfg)) then {...}` |
| `IS_CONTROL(var)` | UI Control | `if (IS_CONTROL(ctrl)) then {...}` |
| `IS_DISPLAY(var)` | UI Display | `if (IS_DISPLAY(disp)) then {...}` |
| `IS_GROUP(var)` | Group object | `if (IS_GROUP(grp)) then {...}` |
| `IS_OBJECT(var)` | Game object | `if (IS_OBJECT(obj)) then {...}` |
| `IS_SCALAR(var)` | Number (scalar) | `if (IS_SCALAR(num)) then {...}` |
| `IS_SCRIPT(var)` | Script handle | `if (IS_SCRIPT(script)) then {...}` |
| `IS_SIDE(var)` | Side (`west`, `east`, etc.) | `if (IS_SIDE(side)) then {...}` |
| `IS_STRING(var)` | String | `if (IS_STRING(str)) then {...}` |
| `IS_TEXT(var)` | Structured text | `if (IS_TEXT(text)) then {...}` |
| `IS_LOCATION(var)` | Map location | `if (IS_LOCATION(loc)) then {...}` |
| `IS_INTEGER(var)` | Integer (scalar with no decimal) | `if (IS_INTEGER(num)) then {...}` |
| `IS_NUMBER(var)` | Any number (alias for IS_SCALAR) | `if (IS_NUMBER(num)) then {...}` |

## Admin Check Macros

| Macro | Checks For |
|-------|-----------|
| `IS_ADMIN` | Voted admin on server |
| `IS_ADMIN_LOGGED` | Logged-in admin on server |

## Localization Macros

| Macro | Purpose |
|-------|---------|
| `ELSTRING(var1,var2)` | Extended localization string: `STRCLib_var1_var2` |
| `LSTRING(var)` | Module localization string: `STRCLib_MODULE_var` |
| `QLSTRING(var)` | Quoted LSTRING: `"STRCLib_MODULE_var"` |
| `QELSTRING(var1,var2)` | Quoted ELSTRING |
| `LOC(var)` | Read localization: `var call CLib_fnc_readLocalization` |
| `MLOC(var)` | Module localization shorthand: `MLOC(greeting)` → `QLSTRING(greeting) call CLib_fnc_readLocalization` |

## UI Positioning Macros

Used for safe-zone aware UI positioning.

| Macro | Purpose |
|-------|---------|
| `PYN` | UI reference height (108) |
| `PX(X)` | Convert X to safe-zone aware X coordinate |
| `PY(Y)` | Convert Y to safe-zone aware Y coordinate |

```sqf
// Example: Position button at (10, 20)
private _pos = [PX(10), PY(20), PX(50), PY(30)];
```

## Execution Context Macros

Control where code can execute.

| Macro | Purpose |
|-------|---------|
| `EXEC_ONLY_UNSCHEDULED` | Exit if called in scheduled environment; redirect to unscheduled via `CFUNC(directCall)` |
| `EXEC_ONLY_IN_NAMESPACE(var)` | Exit if not in specified namespace; redirect execution |
| `EXEC_ONLY_IN_MISSIONNAMESPACE` | Shorthand for `EXEC_ONLY_IN_NAMESPACE(missionNamespace)` |

```sqf
EXEC_ONLY_UNSCHEDULED;
// This code only runs in unscheduled context
```

## Performance & Compression Macros

| Macro | Purpose |
|-------|---------|
| `RUNTIMESTART` | Initialize timing (ISDEV + ENABLEPERFORMANCECOUNTER only) |
| `RUNTIME(var)` | Log execution time in ms; requires `RUNTIMESTART` |
| `USE_COMPRESSION(var)` | Check if compression is enabled for data |

```sqf
RUNTIMESTART;
// ... some code ...
RUNTIME("myFunction");  // Logs: "myFunction Needed: 1.23 ms"
```

## Module Configuration Macros

Used in `cfgCLibModules.hpp` for module/function registration.

| Macro | Purpose | Example |
|-------|---------|---------|
| `DFNC(f)` | Define function class | `DFNC(myFunc)` → `class myFunc` |
| `FNC(f)` | Define function (standard) | `FNC(init)` → `class init {}` |
| `FNCSERVER(f)` | Define server-only function | `FNCSERVER(handleRequest)` |
| `APIFNC(f)` | Define public API function | `APIFNC(doSomething)` |
| `APIFNCSERVER(f)` | Define public server API function | `APIFNCSERVER(request)` |
| `MODULE(m)` | Define module class | `MODULE(PerFrame)` → `class PerFrame` |

```cpp
// Example module definition
MODULE(MyModule) {
    dependency[] = {"CLib/PerFrame"};
    APIFNC(myPublicFunc);
    FNC(myInternalFunc);
    FNCSERVER(myServerFunc);
};
```

## Utility Macros

| Macro | Purpose |
|-------|---------|
| `FUNCTIONNAME` | Current function name (alias for `_fnc_scriptName`) |
| `SCRIPTSCOPENAME` | Unique scope name: `FUNCTIONNAME + "_Main"` |
| `RELDIR(pos1,pos2)` | Relative direction from pos1 to pos2, normalized to [-180, 180] |
| `QPREFIX` | Quoted prefix: `"CLib"` |

```sqf
hint format ["In function: %1", FUNCTIONNAME];
private _dir = RELDIR(getPos player, getPos target);
```

## Deprecated Function Macros

| Macro | Purpose |
|-------|---------|
| `DEPRECATEFUNC(OLD,NEW)` | Mark function as deprecated; redirect calls to new function |
| `REPLACEDFUNC(OLD,NEW,VERSION)` | Mark function as replaced in given version |

```sqf
DEPRECATEFUNC(oldFunc, newFunc);
REPLACEDFUNC(legacyFunc, modernFunc, "0.15.0");
```