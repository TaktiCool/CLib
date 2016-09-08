#include "macros.hpp"

DCFUNC(compile) = compile preprocessFileLineNumbers "\pr\Clib\addons\Clib\Compile\fn_compile.sqf";
DCFUNC(compressString) = compile preprocessFileLineNumbers "\pr\Clib\addons\Clib\Compile\fn_compressString.sqf";
DCFUNC(decompressString) = compile preprocessFileLineNumbers "\pr\Clib\addons\Clib\Compile\fn_decompressString.sqf";
DCFUNC(stripSqf) = compile preprocessFileLineNumbers "\pr\Clib\addons\Clib\Compile\fn_stripSqf.sqf";;
DCFUNC(readAllModulesAndFunctions) = compile preprocessFileLineNumbers "\pr\Clib\addons\Clib\Compile\fn_readAllModulesAndFunctions.sqf";

// The autoloader uses this array to get all function names.
GVAR(functionCache) = [];
call CFUNC(readAllModulesAndFunctions);
