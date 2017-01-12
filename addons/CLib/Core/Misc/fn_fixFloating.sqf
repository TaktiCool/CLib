#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: commy2
    https://github.com/acemod/ACE3/blob/3d5ea74c7ec44dde291765f632df0004cfe101a9/addons/common/functions/fnc_fixFloating.sqf

    Description:
    Attempt to fix floating physx with disabled damage after setPosXXX commands.
    Handles the "fixFloating" event

    Parameter(s):
    0: PhysX object <Object>

    Returns:
    None
*/
params ["_object"];

// setHitPointDamage requires local object
if (!local _object) exitWith {
    ["fixFloating", _object, _object] call CFUNC(targeEvent);
};
//Ignore mans
if (_object isKindOf "CAManBase") exitWith {};

//We need to manually set allowDamage to true for setHitIndex to function
["blockDamage", [_object, false]] call CFUNC(localEvent);

// save and restore hitpoints, see below why
private _hitPointDamages = getAllHitPointsDamage _object;

// get correct format for objects without hitpoints
if (_hitPointDamages isEqualTo []) then {
    _hitPointDamages = [[],[],[]];
};

// this prevents physx objects from floating when near other physx objects with allowDamage false
_object setDamage (damage _object);

{
    _object setHitIndex [_forEachIndex, _x];
} forEach (_hitPointDamages select 2);
