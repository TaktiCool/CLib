#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    apply the Loadout to a Unit

    Parameter(s):
    0: Unit that get the Loadout <Object>
    1: Classname <String>

    Returns:
    None
*/
params [["_unit", player , [objNull]], ["_class", "", ["", configNull, []]]];

private _loadoutArray = _class call CFUNC(loadLoadout);

private _loadout = _loadoutArray select 0;
private _loadoutVars = _loadoutArray select 1;


diag_log [_class, _loadoutVars];

private _fnc_do = {
    params ["_find", "_do", ["_isRandom", false]];
    private _i = _loadout find _find;
    if (_i != -1) then {
        private _item = if (_isRandom) then {
            selectRandom (_loadout select (_i + 1));
        } else {
            _loadout select (_i + 1);
        };
        call _do;
    };
};

// Remove Actions
["removeAllWeapons", { if (_item isEqualTo 1) then { removeAllWeapons _unit; }; }] call _fnc_do;
["removeAllItems", { if (_item isEqualTo 1) then { removeAllItems _unit; }; }] call _fnc_do;
["removeAllAssingedItems", { if (_item isEqualTo 1) then { removeAllAssignedItems _unit; }; }] call _fnc_do;


// Uniform
["uniform", {
    if (_item != "") then {
        [_unit, _item, 0] call CFUNC(addContainer);
    };
}, true] call _fnc_do;

// Vest
["vest", {
    if (_item != "") then {
        [_unit, _item, 1] call CFUNC(addContainer);
    };
}, true] call _fnc_do;

// Backpack
["backpack", {
    if (_item != "") then {
        [_unit, _item, 3] call CFUNC(addContainer);
    };
}, true] call _fnc_do;

// Headgear
["headgear", {
    if (_item != "") then {
        removeHeadgear _unit; _unit addHeadgear _item;
    };
}, true] call _fnc_do;

// Goggles
["goggle", {
    if (_item != "") then {
        removeGoggles _unit; _unit addGoggles _item;
    };
}, true] call _fnc_do;

// Weapons
{
    [_x, { _unit addWeapon _item; }, true] call _fnc_do;
    nil
} count ["primaryWeapon","secondaryWeapon","handgun","binocular"];

// Primary Weapon Items
{
    [_x, { _unit addPrimaryWeaponItem _item; }, true] call _fnc_do;
    nil
} count ["primaryWeaponOptic","primaryWeaponMuzzle","primaryWeaponBarrel","primaryWeaponResting","primaryWeaponLoadedMagazine"];

// Secondary Weapon Items
{
    [_x, { _unit addSecondaryWeaponItem _item; }, true] call _fnc_do;
    nil
} count ["secondaryWeaponOptic","secondaryWeaponMuzzle","secondaryWeaponBarrel","secondaryWeaponResting","secondaryWeaponLoadedMagazine"];

// Handgun Items
{
    [_x, { _unit addHandgunItem _item; }, true] call _fnc_do;
    nil
} count ["handgunOptic","handgunMuzzle","handgunBarrel","handgunResting","handgunLoadedMagazine"];

// Items to Uniform
["itemsUniform", {
    {
        if (_x isEqualType []) then {
            for "_i" from 1 to (_x select 1) do {
                _unit addItemToUniform (_x select 0);
            };
        };
        if (_x isEqualType "") then {
            _unit addItemToUniform _x;
        };
        nil
    } count _item;
}, true] call _fnc_do;

// Items to Vest
["itemsVest", {
    {
        if (_x isEqualType []) then {
            for "_i" from 1 to (_x select 1) do {
                _unit addItemToVest (_x select 0);
            };
        };
        if (_x isEqualType "") then {
            _unit addItemToVest _x;
        };
        nil
    } count _item;
}, false] call _fnc_do;

// Items to Backpack
["itemsBackpack", {
    {
        if (_x isEqualType []) then {
            for "_i" from 1 to (_x select 1) do {
                _unit addItemToBackpack (_x select 0);
            };
        };
        if (_x isEqualType "") then {
            _unit addItemToBackpack _x;
        };
        nil
    } count _item;
}, false] call _fnc_do;

// Magazines
["magazines", {
    {
        if (_x isEqualType []) then {
            _unit addMagazines _x;
        };
        if (_x isEqualType "") then {
            _unit addMagazine _x;
        };
        nil
    } count _item;
}, false] call _fnc_do;


// Items
["items", {
    {
        if (_x isEqualType []) then {
            for "_i" from 1 to (_x select 1) do {
                _unit addItem (_x select 0);
            };
        };
        if (_x isEqualType "") then {
            _unit addItem _x;
        };
        nil
    } count _item;
}, false] call _fnc_do;


// Linked Items
["linkedItems", {
    {
        _unit linkItem _x;
        nil
    } count _item;
}, false] call _fnc_do;

// Scripts
["script", {
    {
        [_unit,_loadout] call compile _x;
        nil
    } count _item;
}, false] call _fnc_do;

["unitTrait", {
    {
        _unit setUnitTrait _x;
        nil
    } count _item;
}, false] call _fnc_do;

if !(_loadoutVars isEqualTo []) then {
    for "_i" from 0 to (count _loadoutVars) step 2 do {
        private _name = _loadoutVars select _i;
        private _value = _loadoutVars select (_i + 1);

        _unit setVariable [_name, _value, true];
    };
};