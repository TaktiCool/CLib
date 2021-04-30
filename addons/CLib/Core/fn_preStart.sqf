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

if (isNil QCFUNC(compile)) then {
    DCFUNC(compile) = compileScript ["\tc\CLib\addons\CLib\Core\Compile\fn_compile.sqf", false];
};
if (isNil QCFUNC(stripSqf)) then {
    DCFUNC(stripSqf) = compileScript ["\tc\CLib\addons\CLib\Core\Compile\fn_stripSqf.sqf", false];
};
if (isNil QCFUNC(readAllModules)) then {
    DCFUNC(readAllModules) = compileScript ["\tc\CLib\addons\CLib\Core\Compile\fn_readAllModules.sqf", false];
};
if (isNil QCFUNC(readAllFunctions)) then {
    DCFUNC(readAllFunctions) = compileScript ["\tc\CLib\addons\CLib\Core\Compile\fn_readAllFunctions.sqf", false];
};
if (isNil QCFUNC(compileAllFunctions)) then {
    DCFUNC(compileAllFunctions) = compileScript ["\tc\CLib\addons\CLib\Core\Compile\fn_compileAllFunctions.sqf", false];
};
if (isNil QCFUNC(buildDependencyGraph)) then {
    DCFUNC(buildDependencyGraph) = compileScript ["\tc\CLib\addons\CLib\Core\Compile\fn_buildDependencyGraph.sqf", false];
};
if (isNil QCFUNC(compressString)) then {
    DCFUNC(compressString) = compileScript ["\tc\CLib\addons\CLib\Core\Compression\fn_compressString.sqf", false];
};
if (isNil QCFUNC(decompressString)) then {
    DCFUNC(decompressString) = compileScript ["\tc\CLib\addons\CLib\Core\Compression\fn_decompressString.sqf", false];
};
if (isNil QCFUNC(checkCompression)) then {
    DCFUNC(checkCompression) = compileScript ["\tc\CLib\addons\CLib\Core\Compression\fn_checkCompression.sqf", false];
};
if (isNil QCFUNC(checkAllFunctionCompression)) then {
    DCFUNC(checkAllFunctionCompression) = compileScript ["\tc\CLib\addons\CLib\Core\Compression\fn_checkAllFunctionCompression.sqf", false];
};
if (isNil QCFUNC(log)) then {
    DCFUNC(log) = compileScript ["\tc\CLib\addons\CLib\Core\Misc\fn_log.sqf", false];
};
if (isNil QCFUNC(codeToString)) then {
    DCFUNC(codeToString) = compileScript ["\tc\CLib\addons\CLib\Core\Misc\fn_codeToString.sqf", false];
};

call (compileScript ["\tc\CLib\addons\CLib\Core\ExtensionFramework\fn_preStart.sqf", false]);

CGVAR(playerUID) = "";

#ifndef ISDEV
    if (isNil {parsingNamespace getVariable QCGVAR(allFunctionNamesCached)}) then {
#endif
call CFUNC(readAllModules);
call CFUNC(buildDependencyGraph);
call CFUNC(readAllFunctions);
#ifndef ISDEV
    };
#endif

call CFUNC(compileAllFunctions);
private _strTime = ((diag_tickTime - _startTime) * 1000) call CFUNC(toFixedNumber);
LOG("Reading and Compiling all Function and Modules Required: " +  _strTime + " ms")
