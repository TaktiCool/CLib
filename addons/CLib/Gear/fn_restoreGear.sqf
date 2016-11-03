#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Restore gear from saveGear Function to destination

    Parameter(s):
    0: Gear <Array>
    1: Destination Unit <Object>

    Returns:
    None
*/
params ["_gear", "_u2"];
_gear params ["_allGear", "_magazinesAmmoFull"];

_allGear params [
    "_headgear",
    "_goggles",
    "_uniform", "_uniformItems",
    "_vest", "_vestItems",
    "_backpack", "_backpackItems",
    "_primaryWeapon", "_primaryWeaponItems", "_primaryWeaponMagazine",
    "_secondaryWeapon", "_secondaryWeaponItems", "_secondaryWeaponMagazine",
    "_handgun", "_handgunItems", "_handgunMagazine",
    "_assignedItems",
    "_binocular"
];

// DUMP(_allGear)
// DUMP(_magazinesAmmoFull)

removeAllAssignedItems _u2;
removeAllWeapons _u2;
removeHeadgear _u2;
removeGoggles _u2;

[_u2, _uniform] call CFUNC(addContainer);
[_u2, _vest] call CFUNC(addContainer);
[_u2, _backpack] call CFUNC(addContainer);
_u2 addHeadgear _headgear;


_primaryWeapon = [_primaryWeapon] call BIS_fnc_baseWeapon;
_secondaryWeapon = [_secondaryWeapon] call BIS_fnc_baseWeapon;
_handgun = [_handgun] call BIS_fnc_baseWeapon;


_assignedItems = _assignedItems - [_binocular];


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
} count [_primaryWeapon, _secondaryWeapon, _handgun, _binocular];

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
} count _assignedItems;

{
    _u2 addPrimaryWeaponItem _x;
    nil
} count _primaryWeaponItems;

{
    _u2 addHandgunItem _x;
    nil
} count _handgunItems;

{
    _u2 addSecondaryWeaponItem _x;
    nil
} count _secondaryWeaponItems;
