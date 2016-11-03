#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Write Log

    Parameter(s):
    0: Type of Logging <String>
    1: Mod Name <String>
    2: Module Name <String>
    3: Log <Any>
    4: File Path <String>
    5: Line <Number>

    Returns:
    None
*/
params ["_name", "_modName", "_module", "_var", "_file", "_line"];


#ifdef isDev
    private _formatStr = "(%1) [%2 %3 - %4]: %5 %6:%7";
#else
    private _formatStr = "(%1) [%2 %3 - %4]: %5";
#endif
private _str = format [_formatStr, diag_frameNo, _modName, _name, _module, _var, _file, _line];
diag_log _str;
#ifdef isDev
    systemChat _str;
    if (hasInterface) then {
        CGVAR(sendlogfile) = [_str, format ["%1_%2", profileName, CGVAR(playerUID)]];
        publicVariableServer QCGVAR(sendlogfile);
    };
#endif
