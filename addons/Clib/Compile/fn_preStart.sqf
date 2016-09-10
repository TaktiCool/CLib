#include "macros.hpp"

private _startTime = diag_tickTime;
Clib_fnc_compile = compile preprocessFileLineNumbers "\pr\Clib\addons\Clib\Compile\fn_compile.sqf";
Clib_fnc_compressString = compile preprocessFileLineNumbers "\pr\Clib\addons\Clib\Compile\fn_compressString.sqf";
Clib_fnc_stripSqf = compile preprocessFileLineNumbers "\pr\Clib\addons\Clib\Compile\fn_stripSqf.sqf";
Clib_fnc_readAllModulesAndFunctions = compile preprocessFileLineNumbers "\pr\Clib\addons\Clib\Compile\fn_readAllModulesAndFunctions.sqf";
Clib_fnc_compileAllFunctions = compile preprocessFileLineNumbers "\pr\Clib\addons\Clib\Compile\fn_compileAllFunctions.sqf";

// The autoloader uses this array to get all function names.
CGVAR(functionCache) = [];
call CFUNC(readAllModulesAndFunctions);
call CFUNC(compileAllFunctions);
LOG("Reading and Compiling Required: "+str ((diag_tickTime - _startTime) * 1000) + " ms")
