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
CLib_fnc_readAllModules = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Compile\fn_readAllModules.sqf";
CLib_fnc_readAllFunctions = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Compile\fn_readAllFunctions.sqf";
CLib_fnc_compileAllFunctions = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Compile\fn_compileAllFunctions.sqf";
CLib_fnc_buildDependencyGraph = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Compile\fn_buildDependencyGraph.sqf";
CLib_playerUID = "";

if !(isNil {parsingNamespace getVariable QCGVAR(allFunctionNamesCached)}) then {
    call CFUNC(readAllModules);
    call CFUNC(buildDependencyGraph);
    call CFUNC(readAllFunctions);
};
call CFUNC(compileAllFunctions);
LOG("Reading and Compiling all Function and Modules Required: " + str ((diag_tickTime - _startTime) * 1000) + " ms")
