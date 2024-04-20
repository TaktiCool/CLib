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

#ifdef ISDEV
    #define COMPILE_FILE(script) compile preprocessFileLineNumbers script
#else
    #define COMPILE_FILE(script) compileScript [script, false]
#endif
if (isNil QCFUNC(compile)) then {
    DCFUNC(compile) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Compile\fn_compile.sqf");
};
if (isNil QCFUNC(stripSqf)) then {
    DCFUNC(stripSqf) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Compile\fn_stripSqf.sqf");
};
if (isNil QCFUNC(readAllModules)) then {
    DCFUNC(readAllModules) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Compile\fn_readAllModules.sqf");
};
if (isNil QCFUNC(readAllFunctions)) then {
    DCFUNC(readAllFunctions) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Compile\fn_readAllFunctions.sqf");
};
if (isNil QCFUNC(compileAllFunctions)) then {
    DCFUNC(compileAllFunctions) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Compile\fn_compileAllFunctions.sqf");
};
if (isNil QCFUNC(buildDependencyGraph)) then {
    DCFUNC(buildDependencyGraph) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Compile\fn_buildDependencyGraph.sqf");
};
if (isNil QCFUNC(compressString)) then {
    DCFUNC(compressString) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Compression\fn_compressString.sqf");
};
if (isNil QCFUNC(decompressString)) then {
    DCFUNC(decompressString) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Compression\fn_decompressString.sqf");
};
if (isNil QCFUNC(checkCompression)) then {
    DCFUNC(checkCompression) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Compression\fn_checkCompression.sqf");
};
if (isNil QCFUNC(checkAllFunctionCompression)) then {
    DCFUNC(checkAllFunctionCompression) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Compression\fn_checkAllFunctionCompression.sqf");
};
if (isNil QCFUNC(log)) then {
    DCFUNC(log) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Misc\fn_log.sqf");
};
if (isNil QCFUNC(codeToString)) then {
    DCFUNC(codeToString) = COMPILE_FILE("\tc\CLib\addons\CLib\Core\Misc\fn_codeToString.sqf");
};

call (COMPILE_FILE("\tc\CLib\addons\CLib\Core\ExtensionFramework\fn_preStart.sqf"));

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
