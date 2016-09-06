#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: joko // Jonas

    Description:
    Compile and Compress a function

    Parameter(s):
    0: Path to Function <STRING>
    1: Function Name <STRING>

    Returns:
    None
*/
params [["_functionPath", "", [""]], ["_functionVarName", "", [""]], ["_mod", "Clib"]];

#ifdef DEBUGFULL
    private _debug = "private _fnc_scriptMap = if (isNil '_fnc_scriptMap') then {[_fnc_scriptName]} else {_fnc_scriptMap + [_fnc_scriptName]};";
#else
    private _debug = "";
#endif

#define SCRIPTHEADER "\
private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {\
    '%1'\
} else {\
    _fnc_scriptName\
};\
private _fnc_scriptName = '%1';\
scriptName _fnc_scriptName;\
scopeName _fnc_scriptName + '_Main';\
%2\
\
"

#ifndef isDev
    private _cachedFunction = parsingNamespace getVariable _functionVarName;
    private _fncCode = if (isNil "_cachedFunction") then {
        private _header = format [SCRIPTHEADER, _functionVarName, _debug];
        private _funcString = _header + preprocessFileLineNumbers _functionPath;
        _funcString = _funcString call CFUNC(stripSqf);

        compileFinal _funcString;
    } else {
        _cachedFunction
    };
#else
    private _header = format [SCRIPTHEADER, _functionVarName, _debug];
    private _funcString = _header + preprocessFileLineNumbers _functionPath;

    private _fncCode = compile _funcString;
#endif

{
    _x setVariable [_functionVarName, _fncCode];
    nil
} count [missionNamespace, uiNamespace, parsingNamespace];

GVAR(functionCache) pushBackUnique _functionVarName;

// save Compressed Version Only in Parsing Namespace if the Variable not exist
#ifdef disableCompression
    #define useCompression false
#else
    #define useCompression isNil {parsingNamespace getVariable (_functionVarName + "_Compressed")
#endif
if (useCompression) then {
    #ifdef isDev
        private _compressedString = _funcString call CFUNC(compressString);
        parsingNamespace setVariable [_functionVarName + "_Compressed", _compressedString];

        private _str = format ["Compress Functions: %1 %2 %3", _functionVarName, str ((count _compressedString / count _funcString) * 100), "%"];
        DUMP(_str)
        private _var = _compressedString call CFUNC(decompressString);
        DUMP("Compressed Functions is Damaged: " + str (!(_var isEqualTo _funcString)))
    #else
        parsingNamespace setVariable [_functionVarName + "_Compressed", _funcString call CFUNC(compressString)];
    #endif
};
nil
