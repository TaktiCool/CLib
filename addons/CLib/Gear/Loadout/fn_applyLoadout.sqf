#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Applys a loadout to a unit

    Parameter(s):
    0: Unit that get the Loadout <Object> (Default: player)
    1: Classname or config of loadout <Config, String> (Default: "")
    2: Allow Random Items <Bool> (Default: true)

    Returns:
    None
*/

params [
    ["_unit", player, [objNull]],
    ["_class", "", [configNull, ""]],
    ["_allowRandom", true, [true]]
];

if (isNil QGVAR(loadoutsLoaded)) exitWith {
    [{_this call CFUNC(applyLoadout)}, {!isNil QGVAR(loadoutsLoaded)}, _this] call CFUNC(waitUntil); //TODO use event
};

private _loadoutArray = _class call CFUNC(loadLoadout);

private _loadout = _loadoutArray select 1;
private _loadoutVars = _loadoutArray select 0;
DUMP(str _loadout);
private _fnc_do = {
    params ["_find", "_do", ["_isRandom", false]];

    private _items = [_loadout, toLower _find, nil] call CFUNC(getHash);
    DUMP(_find + ": " + format [str _items]);
    if (isNil "_items") exitWith {};
    switch (true) do {
        case (_isRandom && _allowRandom): {
            DUMP("Random");
            private _item = selectRandom _items;
            if (isNil "_item") exitWith {};
            _item call _do;
        };
        case (_isRandom && !_allowRandom): {
            DUMP("Random Not Allowed");
            private _item = _items select 0;
            if (isNil "_item") exitWith {};
            _item call _do;
        };
        case (!_isRandom);
        default {
            DUMP("Not Random");
            if (_items isEqualType []) then {
                {
                    _x call _do;
                    nil
                } count _items;
            } else {
                _items call _do;
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
    [_x, {_unit addWeapon _this}, false] call _fnc_do;
    nil
} count ["primaryWeapon", "secondaryWeapon", "handgun", "binocular"];

// Primary Weapon Items
{
    [_x, {_unit addPrimaryWeaponItem _this}, false] call _fnc_do;
    nil
} count ["primaryWeaponOptic", "primaryWeaponMuzzle", "primaryWeaponBarrel", "primaryWeaponResting", "primaryWeaponLoadedMagazine"];

// Secondary Weapon Items
{
    [_x, {_unit addSecondaryWeaponItem _this}, false] call _fnc_do;
    nil
} count ["secondaryWeaponOptic", "secondaryWeaponMuzzle", "secondaryWeaponBarrel", "secondaryWeaponResting", "secondaryWeaponLoadedMagazine"];

// Handgun Items
{
    [_x, {_unit addHandgunItem _this}, false] call _fnc_do;
    nil
} count ["handgunOptic", "handgunMuzzle", "handgunBarrel", "handgunResting", "handgunLoadedMagazine"];

// Items to Uniform
["itemsUniform", {
    if (_this isEqualType []) then {
        for "_i" from 1 to (_this select 1) do {
            _unit addItemToUniform (_this select 0);
        };
    };
    if (_this isEqualType "") then {
        _unit addItemToUniform _this;
    };
}, false] call _fnc_do;

// Items to Vest
["itemsVest", {
    if (_this isEqualType []) then {
        for "_i" from 1 to (_this select 1) do {
            _unit addItemToVest (_this select 0);
        };
    };
    if (_this isEqualType "") then {
        _unit addItemToVest _this;
    };
}, false] call _fnc_do;

// Items to Backpack
["itemsBackpack", {
    if (_x isEqualType []) then {
        for "_i" from 1 to (_this select 1) do {
            _unit addItemToBackpack (_this select 0);
        };
    };
    if (_x isEqualType "") then {
        _unit addItemToBackpack _this;
    };
    nil
}, false] call _fnc_do;

// Magazines
["magazines", {
    if (_this isEqualType []) then {
        _unit addMagazines _this;
    };
    if (_this isEqualType "") then {
        _unit addMagazine _this;
    };
    nil
}, false] call _fnc_do;

// Items
["items", {
    if (_this isEqualType []) then {
        for "_i" from 1 to (_this select 1) do {
            _unit addItem (_this select 0);
        };
    };
    if (_this isEqualType "") then {
        _unit addItem _this;
    };
}, false] call _fnc_do;

// Linked Items
["linkedItems", {
    _unit linkItem _this;
    nil
}, false] call _fnc_do;

// Scripts
["script", {
    [_unit, _loadout] call compile _this;
}, false] call _fnc_do;

["unitTrait", {
    _unit setUnitTrait _this;
}, false] call _fnc_do;
DUMP(str _loadoutVars);
[_loadoutVars, {
    params ["_key", "_value"];
    _unit setVariable [_key, _value, true];
}] call CFUNC(forEachHash);
