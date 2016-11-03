#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    get the Default Animation for a Unit

    Parameter(s):
    0: Unit <Object>

    Returns:
    Animation <String>

    TODO Cache config Reads
*/
params ["_unit"];
private _animState = toLower (animationState _unit);

// stance are broken for some Animations
private _stance = switch (_animState select [4, 4]) do {
    case ("ppne"): { "pne" };
    case ("pknl"): { "knl" };
    case ("perc"): { "erc" };
    default {
        ["erc", "knl", "pne"] select (["STAND", "CROUCH", "PRONE"] find stance _unit) max 0
    };
};

private _speed = ["stp", "run"] select ((vectorMagnitude (velocity _unit)) > 1);
private _weaponAIndex = ["", primaryWeapon _unit, secondaryWeapon _unit, handgunWeapon _unit, binocular _unit] find (currentWeapon _unit) max 0;
private _weapon = ["non", "rfl", "lnr", "pst", "bin"] select _weaponAIndex;
private _weaponPos = [["ras", "low"] select (weaponLowered _unit), "non"] select (currentWeapon _unit == "");
private _prev = ["non", _animState select [(count _animState) - 1, 1]] select ((_animState select [(count _animState) - 2, 2]) in ["df", "db", "dl", "dr"]);

_animState = format ["AmovP%1M%2S%3W%4D%5", _stance, _speed, _weaponPos, _weapon, _prev];

["", _animState] select isClass (configFile >> "CfgMovesMaleSdr" >> "States" >> _animState)
