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

#ifdef isDev
    private _functionCode = compile (_header + (preprocessFileLineNumbers _functionPath));
#else
    private _functionCode = parsingNamespace getVariable _functionName;
    if (isNil "_functionCode") then {
        _functionCode = compileFinal ((_header + (preprocessFileLineNumbers _functionPath)) call CFUNC(stripSqf));
    };
#endif

DUMP("Compile Function: " + _functionName);

{
    _x setVariable [_functionName, _functionCode];
    nil
} count [missionNamespace, uiNamespace, parsingNamespace];

// save Compressed Version Only in Parsing Namespace if the Variable not exist
#ifdef disableCompression
    #define useCompression false
#else
    #define useCompression isNil {parsingNamespace getVariable (_functionName + "_Compressed")}
#endif

#ifdef isDev
    #define compressionTestStage1 private _str = format ["Compress Functions: %1 %2 %3", _functionName, str ((count _compressedString / count _funcString) * 100), "%"];DUMP(_str)
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
    parsingNamespace setVariable [_functionName + "_Compressed", _compressedString];

    compressionTestStage1
    compressionTestStage2
};
nil
