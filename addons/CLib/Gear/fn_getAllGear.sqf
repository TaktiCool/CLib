#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: bux578, commy2
    https://github.com/acemod/ACE3/blob/c117a79431a1a7f13474878285e9ff3d4407d68e/addons/common/functions/fnc_getAllGear.sqf

    Description:
    Returns an array containing all items of a given unit

    Parameter(s):
    0: Unit <Object> (Default: player)

    Returns:
    Loadout <Array>

    Remarks:
    Loadout
    0: Headgear <String>
    1: Goggles <String>
    2: Uniform <String>
    3: Uniform Items <ARRAY>
    4: Vest <String>
    5: Vest Items <ARRAY>
    6: Backback <String>
    7: Backpack Items <ARRAY>
    8: Rifle <String>
    9: Rifle Items <ARRAY>
    10: Rifle Magazines <ARRAY>
    11: Launcher <String>
    12: Launcher Items <ARRAY>
    13: Launcher Magazines <ARRAY>
    14: Handgun <String>
    15: Handgun Items <ARRAY>
    16: Handgun Magazines <ARRAY>
    17: Assigned Items (map, compass, watch, etc.) <ARRAY>
    18: Binoculars <String>
*/

params [
    ["_unit", player, [objNull]]
];

if (isNull _unit) exitWith {[
    "",
    "",
    "", [],
    "", [],
    "", [],
    "", ["", "", "", ""], [],
    "", ["", "", "", ""], [],
    "", ["", "", "", ""], [],
    [],
    ""
]};

[
    headgear _unit,
    goggles _unit,
    uniform _unit, uniformItems _unit,
    vest _unit, vestItems _unit,
    backpack _unit, backpackItems _unit,
    primaryWeapon _unit, primaryWeaponItems _unit, primaryWeaponMagazine _unit,
    secondaryWeapon _unit, secondaryWeaponItems _unit, secondaryWeaponMagazine _unit,
    handgunWeapon _unit, handgunItems _unit, handgunMagazine _unit,
    assignedItems _unit,
    binocular _unit
]
