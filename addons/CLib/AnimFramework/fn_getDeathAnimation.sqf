#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Gets the death animation for a unit

    Parameter(s):
    0: Unit <Object>

    Returns:
    Death Animation <String>

    TODO Cache config Reads
*/

params ["_unit"];

private _animState = animationState _unit;
private _isInVehicle = isNull (objectParent _unit);
private _varName = format ["%1_%2", _animState, _isInVehicle];
private _return = GVAR(animDeathNamespace) getVariable [_varName, ""];

if (_return != "") exitWith {_return};
private _animConfig = configFile >> "CfgMovesMaleSdr" >> "States";
private _unitAnimCfg = _animConfig >> _animState;

// exit if dead unit is already in the death Anim
if (getNumber (_unitAnimCfg >> "terminal") isEqualTo 1) then {
    _return = _animState;
} else {
    if (isNull (objectParent _unit)) then {
        private _interpolateTo = getArray (_unitAnimCfg >> "interpolateTo");
        {
            if (getNumber (_animConfig >> _x >> "terminal") == 1) exitWith {
                _return = _x;
            };
        } forEach _interpolateTo;
    } else {
        _return = getText (configFile >> "CfgMovesBasic" >> "Actions" >> getText (_unitAnimCfg >> "actions") >> "die");
    };
};
if (_return == "") then {
    _return = "Unconscious";
};
GVAR(animDeathNamespace) setVariable [_varName, _return];
_return
