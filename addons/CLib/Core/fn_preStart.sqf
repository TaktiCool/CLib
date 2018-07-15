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
    DCFUNC(compile) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_compile.sqf";
};
if (isNil QCFUNC(stripSqf)) then {
    DCFUNC(stripSqf) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_stripSqf.sqf";
};
if (isNil QCFUNC(readAllModules)) then {
    DCFUNC(readAllModules) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_readAllModules.sqf";
};
if (isNil QCFUNC(readAllFunctions)) then {
    DCFUNC(readAllFunctions) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_readAllFunctions.sqf";
};
if (isNil QCFUNC(compileAllFunctions)) then {
    DCFUNC(compileAllFunctions) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_compileAllFunctions.sqf";
};
if (isNil QCFUNC(buildDependencyGraph)) then {
    DCFUNC(buildDependencyGraph) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compile\fn_buildDependencyGraph.sqf";
};
if (isNil QCFUNC(compressString)) then {
    DCFUNC(compressString) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compression\fn_compressString.sqf";
};
if (isNil QCFUNC(decompressString)) then {
    DCFUNC(decompressString) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compression\fn_decompressString.sqf";

};
if (isNil QCFUNC(checkCompression)) then {
    DCFUNC(checkCompression) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compression\fn_checkCompression.sqf";
};
if (isNil QCFUNC(checkAllFunctionCompression)) then {
    DCFUNC(checkAllFunctionCompression) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Compression\fn_checkAllFunctionCompression.sqf";
};
if (isNil QCFUNC(log)) then {
    DCFUNC(log) = compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Misc\fn_log.sqf";
};

call compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\ExtensionFramework\fn_preStart.sqf";

CGVAR(playerUID) = "";

#ifdef ISDEV
    call CFUNC(readAllModules);
    call CFUNC(buildDependencyGraph);
    call CFUNC(readAllFunctions);
#else
    if (isNil {parsingNamespace getVariable QCGVAR(allFunctionNamesCached)}) then {
        call CFUNC(readAllModules);
        call CFUNC(buildDependencyGraph);
        call CFUNC(readAllFunctions);
    };
#endif
call CFUNC(compileAllFunctions);
private _strTime = ((diag_tickTime - _startTime) * 1000) call CFUNC(toFixedNumber);
LOG("Reading and Compiling all Function and Modules Required: " +  _strTime + " ms")
