#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Restore gear from saveGear Function to destination

    Parameter(s):
    0: Gear <Array> (Default: [[], []])
    1: Destination Unit <Object> (Default: player)

    Returns:
    None
*/

params [
    ["_gear", [[], []], [[]]],
    ["_unit", player, [objNull]]
];

_gear params ["_allGear", "_magazinesAmmoFull"];

_allGear params [
    "_headgear",
    "_goggles",
    "_uniform", "_uniformItems",
    "_vest", "_vestItems",
    "_backpack", "_backpackItems",
    "_primaryWeapon", "_primaryWeaponItems", "",
    "_secondaryWeapon", "_secondaryWeaponItems", "",
    "_handgun", "_handgunItems", "",
    "_assignedItems",
    "_binocular"
];

removeAllAssignedItems _unit;
removeAllWeapons _unit;
removeHeadgear _unit;
removeGoggles _unit;

[_unit, _uniform, 0] call CFUNC(addContainer);
[_unit, _vest, 1] call CFUNC(addContainer);
[_unit, _backpack, 2] call CFUNC(addContainer);
_unit addHeadgear _headgear;
_unit addGoggles _goggles;

_primaryWeapon = [_primaryWeapon] call BIS_fnc_baseWeapon;
_secondaryWeapon = [_secondaryWeapon] call BIS_fnc_baseWeapon;
_handgun = [_handgun] call BIS_fnc_baseWeapon;

_assignedItems = _assignedItems - [_binocular];

{
    _x params ["_magazine", "_count", "_isLoaded", "_type", "_location"];

    if (_isLoaded && _type > 0) then {
        _unit addMagazine [_magazine, _count];
    };
} forEach _magazinesAmmoFull;

{
    if (_x != "") then {
        _unit addWeapon _x;
    };
} forEach [_primaryWeapon, _secondaryWeapon, _handgun, _binocular];

{
    _x params ["_magazine", "_count", "_isLoaded", "", "_location"];

    if (!_isLoaded) then {
        private _container = objNull;
        if (_location == "Uniform") then {
            _container = uniformContainer _unit;
            private _ind = _uniformItems find _magazine;
            if (_ind != -1) then {
                _uniformItems deleteAt _ind;
            };
        };
        if (_location == "Vest") then {
            _container = vestContainer _unit;
            private _ind = _vestItems find _magazine;
            if (_ind != -1) then {
                _vestItems deleteAt _ind;
            };
        };
        if (_location == "Backpack") then {
            _container = backpackContainer _unit;
            private _ind = _backpackItems find _magazine;
            if (_ind != -1) then {
                _backpackItems deleteAt _ind;
            };
        };
        if (!isNull _container) then {
            _container addMagazineAmmoCargo [_magazine, 1, _count];
        };
    };
} forEach _magazinesAmmoFull;

{
    _unit addItemToUniform _x;
} forEach _uniformItems;
{
    _unit addItemToVest _x;
} forEach _vestItems;
{
    _unit addItemToBackpack _x;
} forEach _backpackItems;

{
    _unit linkItem _x;
} forEach _assignedItems;

{
    _unit addPrimaryWeaponItem _x;
} forEach _primaryWeaponItems;

{
    _unit addHandgunItem _x;
} forEach _handgunItems;

{
    _unit addSecondaryWeaponItem _x;
} forEach _secondaryWeaponItems;
