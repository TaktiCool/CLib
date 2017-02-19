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
private _unitAnimCfg = configFile >> "CfgMovesMaleSdr" >> "States" >> _animState;

// exit if dead unit is already in the death Anim
if (getNumber (_unitAnimCfg >> "terminal") isEqualTo 1) exitWith {_animState};

if (isNull objectParent _unit) exitWith {
    private _interpolateTo = getArray (_unitAnimCfg >> "interpolateTo");
    if !(_interpolateTo isEqualTo []) exitWith {
        _interpolateTo select 0
    };
    "Unconscious"
} else {
    getText (configFile >> "CfgMovesBasic" >> "Actions" >> getText (_unitAnimCfg >> "actions") >> "die")
}
