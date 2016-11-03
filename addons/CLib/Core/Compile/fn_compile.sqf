#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Compile and Compress a function

    Parameter(s):
    0: Path to Function <STRING>
    1: Function Name <STRING>

    Returns:
    None
*/
params [["_functionPath", "", [""]], ["_functionVarName", "", [""]]];

#ifdef DEBUGFULL
    #define DEBUGHEADER "private _fnc_scriptMap = if (isNil '_fnc_scriptMap') then {[_fnc_scriptName]} else {_fnc_scriptMap + [_fnc_scriptName]};"
#else
    #define DEBUGHEADER ""
#endif

#define SCRIPTHEADER "\
private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {\
    '%1'\
} else {\
    _fnc_scriptName\
};\
private _fnc_scriptName = '%1';\
scriptName _fnc_scriptName;\
scopeName (_fnc_scriptName + '_Main');\
%2\
"

#ifdef isDev
    private _header = format [SCRIPTHEADER, _functionVarName, DEBUGHEADER];
    private _funcString = _header + preprocessFileLineNumbers _functionPath;

    private _fncCode = compile _funcString;
#else
    private _fncCode = parsingNamespace getVariable _functionVarName;
    if (isNil "_cachedFunction") then {
        private _header = format [SCRIPTHEADER, _functionVarName, DEBUGHEADER];
        private _funcString = _header + preprocessFileLineNumbers _functionPath;
        _funcString = _funcString call CFUNC(stripSqf);

        _fncCode = compileFinal _funcString;
    };
#endif

DUMP("Compile Function: " + _functionVarName)

{
    _x setVariable [_functionVarName, _fncCode];
    nil
} count [missionNamespace, uiNamespace, parsingNamespace];

// save Compressed Version Only in Parsing Namespace if the Variable not exist
#ifdef disableCompression
    #define useCompression false
#else
    #define useCompression isNil {parsingNamespace getVariable (_functionVarName + "_Compressed")}
#endif

#ifdef isDev
    #define compressionTestStage1 private _str = format ["Compress Functions: %1 %2 %3", _functionVarName, str ((count _compressedString / count _funcString) * 100), "%"];DUMP(_str)
#else
    #define compressionTestStage1 /* disabled */
#endif
#ifdef DEBUGFULL
    #define compressionTestStage2 private _var = _compressedString call CFUNC(decompressString); DUMP("Compressed Functions is Damaged: " + str (!(_var isEqualTo _funcString)))
#else
    #define compressionTestStage2 /* disabled */
#endif

if (useCompression) then {

    private _compressedString = _funcString call CFUNC(compressString);
    parsingNamespace setVariable [_functionVarName + "_Compressed", _compressedString];

    compressionTestStage1
    compressionTestStage2

};
nil
