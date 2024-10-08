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
private _fnc_do = {
    params ["_find", "_do", ["_isRandom", false]];

    private _items = _loadout get (toLowerANSI _find);
    if (isNil "_items") exitWith {};
    switch (true) do {
        case (_isRandom && _allowRandom): {
            private _item = selectRandom _items;
            if (isNil "_item") exitWith {};
            _item call _do;
        };
        case (_isRandom && !_allowRandom): {
            private _item = _items select 0;
            if (isNil "_item") exitWith {};
            _item call _do;
        };
        case (!_isRandom);
        default {
            if (_items isEqualType []) then {
                {
                    _x call _do;
                } forEach _items;
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

// Force Remove Actions
["forceRemoveGoggle", {
    if (_this isEqualTo 1) then {removeGoggles _unit};
}, false] call _fnc_do;
["forceRemoveHeadgear", {
    if (_this isEqualTo 1) then {removeHeadgear _unit};
}, false] call _fnc_do;
["forceRemoveUniform", {
    if (_this isEqualTo 1) then {removeUniform _unit};
}] call _fnc_do;
["forceRemoveVest", {
    if (_this isEqualTo 1) then {removeVest _unit};
}] call _fnc_do;
["forceRemoveBackpack", {
    if (_this isEqualTo 1) then {removeBackpack _unit};
}] call _fnc_do;

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
} forEach ["primaryWeapon", "secondaryWeapon", "handgun", "binocular"];

// Primary Weapon Items
{
    [_x, {_unit addPrimaryWeaponItem _this}, false] call _fnc_do;
} forEach ["primaryWeaponOptic", "primaryWeaponMuzzle", "primaryWeaponBarrel", "primaryWeaponResting", "primaryWeaponLoadedMagazine"];

// Secondary Weapon Items
{
    [_x, {_unit addSecondaryWeaponItem _this}, false] call _fnc_do;
} forEach ["secondaryWeaponOptic", "secondaryWeaponMuzzle", "secondaryWeaponBarrel", "secondaryWeaponResting", "secondaryWeaponLoadedMagazine"];

// Handgun Items
{
    [_x, {_unit addHandgunItem _this}, false] call _fnc_do;
} forEach ["handgunOptic", "handgunMuzzle", "handgunBarrel", "handgunResting", "handgunLoadedMagazine"];

// Items to Uniform
["itemsUniform", {
    [_unit, _this, 0] call CFUNC(addItem);
}, false] call _fnc_do;

// Items to Vest
["itemsVest", {
    [_unit, _this, 1] call CFUNC(addItem);
}, false] call _fnc_do;

// Items to Backpack
["itemsBackpack", {
    [_unit, _this, 2] call CFUNC(addItem);
}, false] call _fnc_do;

// Magazines
["magazines", {
    [_unit, _this] call CFUNC(addMagazine);
}, false] call _fnc_do;

// Items
["items", {
    [_unit, _this, -1] call CFUNC(addItem);
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
    _this params ["_type", "_state", ["_custom", false]];
    if (_state isEqualType "") then {
        _state = call compile _state;
    };
    if (_custom isEqualType "") then {
        _custom = call compile _custom;
    };
    _unit setUnitTrait [_type, _state, _custom];
}, false] call _fnc_do;

{
    _unit setVariable [_x, _y, true];
} forEach _loadoutVars;
