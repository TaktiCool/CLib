#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Compile and Compress a function

    Parameter(s):
    0: Path to Function <String> (Default: "")
    1: Function Name <String> (Default: "")

    Returns:
    None
*/

params [
    ["_functionPath", "", [""]],
    ["_functionName", "", [""]]
];

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
    private "_functionString";
    private _functionCode = parsingNamespace getVariable _functionName;
    if (isNil "_functionCode") then {
        _functionString = (_header + preprocessFileLineNumbers _functionPath) call CFUNC(stripSqf);
        _functionCode = compileFinal _functionString;
    };
#endif

{
    if !((_x getVariable [_functionName, {}]) isEqualTo _functionCode) then {
        _x setVariable [_functionName, _functionCode];
        if !(_x getVariable [_functionName, {}] isEqualTo _functionCode) then {
            LOG("Error: " + _functionName + " could not get overwritten but is different from the current version!");
        };
    };
    nil
} count [missionNamespace, uiNamespace, parsingNamespace];

// save Compressed Version Only in Parsing Namespace if the Variable not exist
#ifndef ISDEV
if (isNil {parsingNamespace getVariable (_functionName + "_Compressed")}) then {
#endif
    #ifdef ISDEV
        private _startTime = diag_tickTime;
    #endif
    if (isNil "_functionString") then {
        _functionString = (_functionCode call CFUNC(codeToString)) call CFUNC(stripSqf);
    };
    private _compressedString = _functionString call CFUNC(compressString);
    // check if Compression was successful else we dont save the string and the Transmision system uses the normal version
    if (_compressedString != "" && _compressedString != GVAR(ACK)) then {
        parsingNamespace setVariable [_functionName + "_Compressed", _compressedString];
        #ifdef ISDEV
            private _str = format ["Compress Functions: %1 %2%4 %3", _functionName, str ((count _compressedString / count _functionString) * 100), (diag_tickTime - _startTime) * 1000, "%"];
            DUMP(_str);
        #endif
        #ifdef DEBUGFULL
            private _var = _compressedString call CFUNC(decompressString);
            DUMP("Compressed Functions is Damaged: " + str (!(_var isEqualTo _functionString)));
        #endif
    };
#ifndef ISDEV
};
#endif
nil
