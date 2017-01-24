#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    PreStart

    Parameter(s):
    None

    Returns:
    None
*/

private _startTime = diag_tickTime;
CLib_fnc_compile = CMP preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_compile.sqf";
CLib_fnc_stripSqf = CMP preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_stripSqf.sqf";
CLib_fnc_readAllModules = CMP preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_readAllModules.sqf";
CLib_fnc_readAllFunctions = CMP preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_readAllFunctions.sqf";
CLib_fnc_compileAllFunctions = CMP preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_compileAllFunctions.sqf";
CLib_fnc_buildDependencyGraph = CMP preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_buildDependencyGraph.sqf";

call compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\ExtensionFramework\fn_preStart.sqf";

CLib_fnc_compressString = CMP preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compression\fn_compressString.sqf";
CLib_fnc_decompressString = CMP preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compression\fn_decompressString.sqf";

CLib_fnc_checkCompression = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compression\fn_checkCompression.sqf";
CLib_fnc_checkAllFunctionCompression = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compression\fn_checkAllFunctionCompression.sqf";

CLib_fnc_log = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Misc\fn_log.sqf";

CLib_playerUID = "";

#ifndef ISDEV
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
