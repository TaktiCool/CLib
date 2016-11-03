#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    get the Death Animation for a Unit

    Parameter(s):
    0: Unit <Object>

    Returns:
    Death Animation <String>

    TODO Cache config Reads
*/

params ["_unit"];

private _animState = animationState _unit;

private _unitAnimCfg = configFile >> "CfgMovesMaleSdr" >> "States" >> _animState;

// exit if death unit is allready in death Anim
if (getNumber (_unitAnimCfg >> "terminal") isEqualTo 1) exitWith {_animState};

private _unitActions = configFile >> "CfgMovesBasic" >> "Actions" >> getText (_unitAnimCfg >> "actions");

private _return = "";
if (isNull (objectParent _unit)) then {
    private _interpolateTo = getArray (_unitAnimCfg >> "interpolateTo");

    scopeName "loopExit";
    {
        if ((_forEachIndex mod 2) == 0) then {
            _return = _x;
            breakTo "loopExit";
        };
    } forEach _interpolateTo;
} else {
    _return = getText (_unitActions >> "die");
};

if (_return == "") then { _return = "Unconscious"; };
_return;
