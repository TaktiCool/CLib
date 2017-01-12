#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: commy2
    https://github.com/acemod/ACE3/blob/3d5ea74c7ec44dde291765f632df0004cfe101a9/addons/common/functions/fnc_fixPosition.sqf

    Description:
    Fixes position of an object. E.g. moves object above ground and adjusts to terrain slope. Requires local object.

    Parameter(s):
    0: Object <Object>

    Returns:
    None
*/
params ["_object"];

// setVectorUp requires local object
if (!local _object) exitWith {
    ["fixPosition", _object] call CFUNC(targetEvent);
};

if ((getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "simulation")) == "house") then {
    //Houses don't have gravity/physics, so make sure they are not floating
    private _posAbove = (getPos _object) select 2;

    if (_posAbove > 0.1) then {
        private _newPosASL = (getPosASL _object) vectorDiff [0,0,_posAbove];
        _object setPosASL _newPosASL;
    };
};

private _position = getPos _object;

// don't place the object below the ground
if (_position select 2 < -0.1) then {
    _position set [2, -0.1];
    _object setPos _position;
};

// adjust position to sloped terrain, if placed on ground
if (getPosATL _object select 2 == _position select 2) then {
    _object setVectorUp surfaceNormal _position;
};
