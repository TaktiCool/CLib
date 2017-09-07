#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Client init for settings framework

    Parameter(s):
    None

    Returns:
    None
*/

{
    if (_x select [0,8] != "classes:" && _x select [0,9] != "settings:") then {
        private _var = GVAR(allSettings) getVariable _x;
        _var params ["_value", "_force", "_isClient"];
        if (_isClient == 1 && {_force == 0}) then {
            _value = profileNamespace getVariable [QGVAR(_x), _value];
            _var set [0, _value];
            GVAR(allSettings) setVariable [_x, _var];
        };
    };
} count allVariables GVAR(allSettings);
