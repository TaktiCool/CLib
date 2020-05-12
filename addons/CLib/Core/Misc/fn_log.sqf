#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Write Log

    Parameter(s):
    0: Name <Anything> (Default: nil)
    1: Mod name <String> (Default: "CLib")
    2: Module name <String> (Default: "")
    3: Variable name <Anything> (Default: nil)
    4: File name <String> (Default: "")
    5: Line number <Number> (Default: 0)
    6: Script name <Anything> (Default: nil)
    7: Parent script name <Anything> (Default: nil)
    8: Script map <Anything> (Default: nil)

    Returns:
    None

    Remarks:
    This Function Should not be called by hand. use DUMP or LOG Macro for that
    [var1, QUOTE(PREFIX), QUOTE(MODULE), var2, __FILE__, __LINE__, _fnc_scriptName, _fnc_scriptNameParent, _fnc_scriptMap] call CLib_fnc_log;
*/

EXEC_ONLY_UNSCHEDULED;

params [
    "_name",
    ["_modName", "CLib", [""]],
    ["_module", "", [""]],
    "_var",
    ["_file", "", [""]],
    ["_line", 0, [0]],
    "_scriptName",
    "_scriptNameParent",
    "_scriptMap"
];

private _formatStr = "(%1) [%2 %3 - %4]: %5";

#ifdef ISDEV
    if !(isNil "_scriptName") then {
        _formatStr = _formatStr + ">%8";
    };
    if !(isNil "_scriptNameParent") then {
        _formatStr = _formatStr + " %9";
    };
    if !(isNil "_scriptMap") then {
        _formatStr = _formatStr + " %10";
    };
    _formatStr = _formatStr + " %6:%7";
#endif
private _str = format [_formatStr, diag_frameNo, _modName, _name, _module, _var, _file, _line, _scriptName, _scriptNameParent, _scriptMap];
diag_log text _str;
#ifdef ISDEV
    systemChat _str;
    if (hasInterface && !isServer) then {
        CGVAR(sendlogfile) = [_str, format ["%1_%2", profileName, CGVAR(playerUID)]];
        publicVariableServer QCGVAR(sendlogfile);
    };
#endif
