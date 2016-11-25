#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Copies gear from source unit to destination

    Parameter(s):
    0: Source Unit <Object>
    1: Destination Unit <Object>

    Returns:
    None
*/

params ["_u1", "_u2"];

removeAllAssignedItems _u2;
removeAllWeapons _u2;
removeHeadgear _u2;
removeGoggles _u2;

[_u2, uniform _u1] call CFUNC(addContainer);
[_u2, vest _u1] call CFUNC(addContainer);
[_u2, backpack _u1] call CFUNC(addContainer);
_u2 addHeadgear headgear _u1;


_uniformItems = uniformItems _u1;
_vestItems = vestItems _u1;
_backpackItems = backpackItems _u1;

_primaryWeapon = [primaryWeapon _u1] call BIS_fnc_baseWeapon;
_secondaryWeapon = [secondaryWeapon _u1] call BIS_fnc_baseWeapon;
_handgunWeapon = [handgunWeapon _u1] call BIS_fnc_baseWeapon;

_magazinesAmmoFull = magazinesAmmoFull _u1;

{
    _x params ["_magazine", "_count", "_isLoaded", "_type", "_location"];

    if (_isLoaded && _type > 0) then {
        _u2 addMagazine [_magazine, _count];
    };
    nil
} count _magazinesAmmoFull;

{
    if (_x != "") then {
        _u2 addWeapon _x;
    };
    nil
} count [_primaryWeapon, _secondaryWeapon, _handgunWeapon];

{
    _x params ["_magazine", "_count", "_isLoaded", "_type", "_location"];

    if (!_isLoaded) then {
        private _container = objNull;
        if (_location == "Uniform") then {
            _container = uniformContainer _u2;
            private _ind = _uniformItems find _magazine;
            if (_ind != -1) then {
                _uniformItems deleteAt _ind;
            };
        };
        if (_location == "Vest") then {
            _container = vestContainer _u2;
            private _ind = _vestItems find _magazine;
            if (_ind != -1) then {
                _vestItems deleteAt _ind;
            };
        };
        if (_location == "Backpack") then {
            _container = backpackContainer _u2;
            private _ind = _backpackItems find _magazine;
            if (_ind != -1) then {
                _backpackItems deleteAt _ind;
            };
        };
        if (!isNull _container) then {
            _container addMagazineAmmoCargo [_magazine, 1, _count];
        };
    };
    nil
} count _magazinesAmmoFull;

{
    _u2 addItemToUniform _x;
    nil
} count _uniformItems;
{
    _u2 addItemToVest _x;
    nil
} count _vestItems;
{
    _u2 addItemToBackpack _x;
    nil
} count _backpackItems;

{
    _u2 linkItem _x;
    nil
} count assignedItems _u1;

{
    _u2 addPrimaryWeaponItem _x
} count primaryWeaponItems _u1;

{
    _u2 addHandgunItem _x
} count handgunItems _u1;

{
    _u2 addSecondaryWeaponItem _x
} count secondaryWeaponItems _u1;
