#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Write Log

    Parameter(s):
    This Function Should not be called by hand. use DUMP or LOG Macro for that

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED

params ["_name", "_modName", "_module", "_var", "_file", "_line", "_scriptName", "_scriptNameParent", "_scriptMap"];

private _formatStr = "(%1) [%2 %3 - %4]: %5";
#ifdef ISDEV

if !(isNil "_scriptNameParent") then {
    _formatStr = _formatStr + " %9";
};
if !(isNil "_scriptName") then {
    _formatStr = _formatStr + ">%8";
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
