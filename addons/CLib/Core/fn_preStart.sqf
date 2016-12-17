#include "macros.hpp"

private _startTime = diag_tickTime;
CLib_fnc_compile = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Compile\fn_compile.sqf";
CLib_fnc_stripSqf = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Compile\fn_stripSqf.sqf";
CLib_fnc_readAllModules = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Compile\fn_readAllModules.sqf";
CLib_fnc_readAllFunctions = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Compile\fn_readAllFunctions.sqf";
CLib_fnc_compileAllFunctions = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Compile\fn_compileAllFunctions.sqf";
CLib_fnc_buildDependencyGraph = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Compile\fn_buildDependencyGraph.sqf";

call compile preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\ExtensionFramework\fn_preStart.sqf";

CLib_fnc_compressString = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Compression\fn_compressString.sqf";
CLib_fnc_decompressString = cmp preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Compression\fn_decompressString.sqf";

CLib_fnc_checkCompression = compile preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Compression\fn_checkCompression.sqf";
CLib_fnc_checkAllFunctionCompression = compile preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Compression\fn_checkAllFunctionCompression.sqf";

CLib_fnc_log = compile preprocessFileLineNumbers "\pr\CLib\addons\CLib\Core\Misc\fn_log.sqf";
publicVariable "CLib_fnc_log";

CLib_playerUID = "";

#ifndef isDev
if (isNil {parsingNamespace getVariable QCGVAR(allFunctionNamesCached)}) then {
    call CFUNC(readAllModules);
    call CFUNC(buildDependencyGraph);
    call CFUNC(readAllFunctions);
};
#else
call CFUNC(readAllModules);
call CFUNC(buildDependencyGraph);
call CFUNC(readAllFunctions);
#endif
call CFUNC(compileAllFunctions);
LOG("Reading and Compiling all Function and Modules Required: " + str ((diag_tickTime - _startTime) * 1000) + " ms")
