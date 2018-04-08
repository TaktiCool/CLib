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

params ["_unit1", "_unit2"];

removeAllAssignedItems _unit2;
removeAllWeapons _unit2;
removeHeadgear _unit2;
removeGoggles _unit2;

[_unit2, uniform _unit1, 0] call CFUNC(addContainer);
[_unit2, vest _unit1, 1] call CFUNC(addContainer);
[_unit2, backpack _unit1, 2] call CFUNC(addContainer);
_unit2 addHeadgear headgear _unit1;


private _uniformItems = uniformItems _unit1;
private _vestItems = vestItems _unit1;
private _backpackItems = backpackItems _unit1;

private _primaryWeapon = [primaryWeapon _unit1] call BIS_fnc_baseWeapon;
private _secondaryWeapon = [secondaryWeapon _unit1] call BIS_fnc_baseWeapon;
private _handgunWeapon = [handgunWeapon _unit1] call BIS_fnc_baseWeapon;

private _magazinesAmmoFull = magazinesAmmoFull _unit1;

{
    _x params ["_magazine", "_count", "_isLoaded", "_type", "_location"];

    if (_isLoaded && _type > 0) then {
        _unit2 addMagazine [_magazine, _count];
    };
    nil
} count _magazinesAmmoFull;

{
    if (_x != "") then {
        _unit2 addWeapon _x;
    };
    nil
} count [_primaryWeapon, _secondaryWeapon, _handgunWeapon];

{
    _x params ["_magazine", "_count", "_isLoaded", "", "_location"];

    if (!_isLoaded) then {
        private _container = objNull;
        if (_location == "Uniform") then {
            _container = uniformContainer _unit2;
            private _ind = _uniformItems find _magazine;
            if (_ind != -1) then {
                _uniformItems deleteAt _ind;
            };
        };
        if (_location == "Vest") then {
            _container = vestContainer _unit2;
            private _ind = _vestItems find _magazine;
            if (_ind != -1) then {
                _vestItems deleteAt _ind;
            };
        };
        if (_location == "Backpack") then {
            _container = backpackContainer _unit2;
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
    _unit2 addItemToUniform _x;
    nil
} count _uniformItems;

{
    _unit2 addItemToVest _x;
    nil
} count _vestItems;

{
    _unit2 addItemToBackpack _x;
    nil
} count _backpackItems;

{
    _unit2 linkItem _x;
    nil
} count (assignedItems _unit1);

{
    _unit2 addPrimaryWeaponItem _x
} count (primaryWeaponItems _unit1);

{
    _unit2 addHandgunItem _x
} count (handgunItems _unit1);

{
    _unit2 addSecondaryWeaponItem _x
} count (secondaryWeaponItems _unit1);
