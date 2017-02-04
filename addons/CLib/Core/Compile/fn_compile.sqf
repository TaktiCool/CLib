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

params [["_functionPath", "", [""]], ["_functionName", "", [""]]];

private _header = format ["\
private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {
    '%1'
} else {
    _fnc_scriptName
};

private _fnc_scriptName = '%1';
scriptName _fnc_scriptName;
scopeName (_fnc_scriptName + '_Main');
", _functionName];

#ifdef DEBUGFULL
    _header = _header + "\
    if (isNil '_fnc_scriptMap') then {\
        _fnc_scriptMap = [_fnc_scriptName];
    } else {
        _fnc_scriptMap pushBack _fnc_scriptName;
    };
    ";
#endif

#ifdef ISDEV
    private _functionString = _header + preprocessFileLineNumbers _functionPath;
    private _functionCode = compile _functionString;
#else
    private _functionCode = parsingNamespace getVariable _functionName;
    if (isNil "_functionCode") then {
        private _functionString = (_header + preprocessFileLineNumbers _functionPath) call CFUNC(stripSqf);
        _functionCode = compileFinal _functionString;
    };
#endif

DUMP("Compile Function: " + _functionName);

{
    _x setVariable [_functionName, _functionCode];
    nil
} count [missionNamespace, uiNamespace, parsingNamespace];

// save Compressed Version Only in Parsing Namespace if the Variable not exist
#ifdef DISABLECOMPRESSION
    #define USECOMPRESSION false
#else
    #define USECOMPRESSION isNil {parsingNamespace getVariable (_functionName + "_Compressed")}
#endif

if (USECOMPRESSION) then {
    private _compressedString = _functionString call CFUNC(compressString);
    parsingNamespace setVariable [_functionName + "_Compressed", _compressedString];

    #ifdef ISDEV
        private _str = format ["Compress Functions: %1 %2 %3", _functionName, str ((count _compressedString / count _functionString) * 100), "%"];
        DUMP(_str);
    #endif
    #ifndef DEBUGFULL
        private _var = _compressedString call CFUNC(decompressString);
        DUMP(count _var);
        DUMP(_var isEqualTo _functionString);
        DUMP("Compressed Functions is Damaged: " + str (!(_var isEqualTo _functionString)));
    #endif
};
nil
