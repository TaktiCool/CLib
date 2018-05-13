#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Applys a loadout to a unit

    Parameter(s):
    0: Unit that get the Loadout <Object>
    1: Classname <String>
    2: Allow Random Items <Bool> (Default: true)
    Returns:
    None
*/
if (isNil QGVAR(loadoutsLoaded)) exitWith {
    [{
        _this call CFUNC(applyLoadout);
    }, {
        !isNil QGVAR(loadoutsLoaded)
    }, _this] call CFUNC(waitUntil);
};

params [["_unit", player, [objNull]], ["_class", "", ["", []]], ["_allowRandom", true, [true]]];
private _loadoutArray = _class call CFUNC(loadLoadout);

private _loadout = _loadoutArray select 0;
private _loadoutVars = _loadoutArray select 1;

private _fnc_do = {
    params ["_find", "_do", ["_isRandom", false]];

    private _i = _loadout find toLower _find;
    if (_i != -1) then {
        private _item = _loadout select (_i + 1);
        if (_isRandom) then {
            if (_allowRandom) then {
                _item = selectRandom _item;
                if (isNil "_item") exitWith {};
                _item call _do;
            } else {
                {
                    _x call _do;
                    nil
                } count _item;
            };
        };

    };
};

// Remove Actions
["removeAllWeapons", {
    if (_this isEqualTo 1) then {removeAllWeapons _unit};
}, false] call _fnc_do;
["removeAllItems", {
    if (_this isEqualTo 1) then {removeAllItems _unit};
}, false] call _fnc_do;
["removeAllAssignedItems", {
    if (_this isEqualTo 1) then {removeAllAssignedItems _unit};
}, false] call _fnc_do;

// Uniform
["uniform", {
    [_unit, _this, 0] call CFUNC(addContainer);
}, true] call _fnc_do;

// Vest
["vest", {
    [_unit, _this, 1] call CFUNC(addContainer);
}, true] call _fnc_do;

// Backpack
["backpack", {
    [_unit, _this, 2] call CFUNC(addContainer);
}, true] call _fnc_do;

// Headgear
["headgear", {
    if (_this != "") then {
        removeHeadgear _unit;
        _unit addHeadgear _this;
    };
}, true] call _fnc_do;

// Goggles
["goggle", {
    if (_this != "") then {
        removeGoggles _unit;
        _unit addGoggles _this;
    };
}, true] call _fnc_do;

// Weapons
{
    [_x, {_unit addWeapon _this}, true] call _fnc_do;
    nil
} count ["primaryWeapon", "secondaryWeapon", "handgun", "binocular"];

// Primary Weapon Items
{
    [_x, {_unit addPrimaryWeaponItem _this}, true] call _fnc_do;
    nil
} count ["primaryWeaponOptic", "primaryWeaponMuzzle", "primaryWeaponBarrel", "primaryWeaponResting", "primaryWeaponLoadedMagazine"];

// Secondary Weapon Items
{
    [_x, {_unit addSecondaryWeaponItem _this}, true] call _fnc_do;
    nil
} count ["secondaryWeaponOptic", "secondaryWeaponMuzzle", "secondaryWeaponBarrel", "secondaryWeaponResting", "secondaryWeaponLoadedMagazine"];

// Handgun Items
{
    [_x, {_unit addHandgunItem _this}, true] call _fnc_do;
    nil
} count ["handgunOptic", "handgunMuzzle", "handgunBarrel", "handgunResting", "handgunLoadedMagazine"];

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
    } count _this;
}, false] call _fnc_do;

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
    } count _this;
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
    } count _this;
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
    } count _this;
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
    } count _this;
}, false] call _fnc_do;


// Linked Items
["linkedItems", {
    {
        _unit linkItem _x;
        nil
    } count _this;
}, false] call _fnc_do;

// Scripts
["script", {
    {
        [_unit, _loadout] call compile _x;
        nil
    } count _this;
}, false] call _fnc_do;

["unitTrait", {
    {
        _unit setUnitTrait _x;
        nil
    } count _this;
}, false] call _fnc_do;

if !(_loadoutVars isEqualTo []) then {
    for "_i" from 0 to (count _loadoutVars) - 1 step 2 do {
        private _name = _loadoutVars select _i;
        private _value = _loadoutVars select (_i + 1);

        _unit setVariable [_name, _value, true];
    };
};
