#include "macros.hpp"

#ifdef isDev
    #define cmp compile
#else
    #define cmp compileFinal
#endif

private _startTime = diag_tickTime;
CLib_fnc_compile = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Compile\fn_compile.sqf";
CLib_fnc_compressString = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Compile\fn_compressString.sqf";
CLib_fnc_stripSqf = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Compile\fn_stripSqf.sqf";
CLib_fnc_readAllModulesAndFunctions = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Compile\fn_readAllModulesAndFunctions.sqf";
CLib_fnc_compileAllFunctions = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Compile\fn_compileAllFunctions.sqf";
CLib_playerUID = "";
// The autoloader uses this array to get all function names.
CGVAR(functionCache) = [];
call CFUNC(readAllModulesAndFunctions);
call CFUNC(compileAllFunctions);
LOG("Reading and Compiling Required: "+str ((diag_tickTime - _startTime) * 1000) + " ms")
