#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: commy2
    https://github.com/acemod/ACE3/blob/3d5ea74c7ec44dde291765f632df0004cfe101a9/addons/common/functions/fnc_fixFloating.sqf

    Description:
    Attempt to fix floating physx with disabled damage after setPosXXX commands.
    Handles the fixFloating event

    Parameter(s):
    0: PhysX object <Object>

    Returns:
    None
*/

params ["_object"];

// Ensure locality and ignore men
if (_object isKindOf "CAManBase" || !local _object) exitWith {};

// We need to manually set allowDamage to true for setHitIndex to function
_object allowDamage true;

// Save and restore hitpoints, see below why
private _hitPointDamages = getAllHitPointsDamage _object;

// Get correct format for objects without hitpoints
if (_hitPointDamages isEqualTo []) then {
    _hitPointDamages = [[], [], []];
};

// This prevents physx objects from floating when near other physx objects with allowDamage false
_object setDamage (damage _object);

{
    _object setHitIndex [_forEachIndex, _x];
} forEach (_hitPointDamages select 2);
