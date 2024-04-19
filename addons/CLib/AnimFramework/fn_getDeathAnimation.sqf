#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Gets the death animation for a unit

    Parameter(s):
    0: Unit <Object> (Default: objNull)

    Returns:
    Death Animation <String>

    Remarks:
    TODO Cache config Reads
*/

params [
    ["_unit", objNull, [objNull]]
];

private _animState = animationState _unit;
private _isInVehicle = isNull (objectParent _unit);
private _varName = format ["%1_%2", _animState, _isInVehicle];
private _return = GVAR(animDeathNamespace) getOrDefault [toLower _varName, ""];

if (_return != "") exitWith {_return};
private _animConfig = configFile >> "CfgMovesMaleSdr" >> "States";
private _unitAnimCfg = _animConfig >> _animState;

// exit if dead unit is already in the death Anim
if (getNumber (_unitAnimCfg >> "terminal") isEqualTo 1) then {
    _return = _animState;
} else {
    if (_isInVehicle) then {
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
GVAR(animDeathNamespace) set [toLower _varName, _return];
_return
