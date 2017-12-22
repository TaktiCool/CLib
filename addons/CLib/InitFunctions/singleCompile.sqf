#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: Karel Moricky, Killzone_Kid
    a3\functions_f\initFunctions.sqf

    Description:
    -

    Parameter(s):
    None

    Returns:
    None
*/
/******************************************************************************************************
    COMPILE ONE FUNCTION

    When input is string containing function name instead of number, only the function is recompiled.

    The script stops here, reads function's meta data and recompile the function
    based on its extension and header.

    Instead of creating missionNamespace shortcut, it saves the function directly. Use it only for debugging!

******************************************************************************************************/

if (_recompile isEqualType "") exitwith {

    //--- Recompile specific function
    private _fnc_uiNamespace = true;
    private _fnc = uiNamespace getVariable _recompile;
    if (isNil "_fnc") then {_fnc = missionNamespace getVariable _recompile; _fnc_uiNamespace = false;};
    if !(isNil "_fnc") then {
        private _fncMeta = _recompile call (uiNamespace getVariable "BIS_fnc_functionMeta");
        private _headerType = if (count _this > 1) then {_this select 1} else {0};
        private _var = [_recompile, [_recompile, _fncMeta, _headerType, false] call _fncCompile];
        if (cheatsEnabled && {_fnc_uiNamespace}) then {uiNamespace setVariable _var;}; //--- Cannot recompile compileFinal functions in public version
        missionNamespace setVariable _var;
        if (isNil "_functions_listRecompile") then {
            textLogFormat ["Log: [Functions]: %1 recompiled with meta %2",_recompile,_fncMeta];
        };
    } else {
        private _fncError = uiNamespace getVariable "BIS_fnc_error";
        if !(isNil "_fncError") then {
            ["%1 is not a function.",_recompile] call _fncError;
        } else {
            textLogFormat ["Log: [Functions]: ERROR: %1 is not a function.",_recompile];
        };
    };
};
