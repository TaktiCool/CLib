#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: commy2
    https://github.com/acemod/ACE3/blob/3d5ea74c7ec44dde291765f632df0004cfe101a9/addons/common/functions/fnc_fixPosition.sqf

    Description:
    Fixes position of an object. Moves object above ground and adjusts to terrain slope. Requires local object.

    Parameter(s):
    0: Object <Object> (Default: objNull)

    Returns:
    None
*/

params [
    ["_object", objNull, [objNull]]
];

private _position = getPosATL _object;
if ((getText (configOf _object >> "simulation")) == "house") then {
    // Houses don't have gravity/physics, so make sure they are not floating
    if (_position select 2 > 0) then {
        _object setVehiclePosition [_position, [], 0, "CAN_COLLIDE"];
    };
};

// don't place the object below the ground
if (_position select 2 < 0) then {
    _object setVehiclePosition [_position, [], 0, "CAN_COLLIDE"];
};

// adjust position to sloped terrain, if placed on ground
_position = getPosATL _object;
if (abs (_position select 2) < 0.1) then {
    ["setVectorUp", _object, [_object, surfaceNormal _position]] call CFUNC(targetEvent);
};
