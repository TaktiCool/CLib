#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add weapon Wraper

    Parameter(s):
    0: Unit <Object> (Default: objNull)
    1: Weapon classsname <String> (Default: "")
    2: Magazine data <Array> (Default: ["", 0])

    Returns:
    None
*/

params [
    ["_unit", objNull, [objNull]],
    ["_className", "", [""]],
    ["_magazineData", ["", 0], [[]], 2]
];

if (_className != "") then {
    [_unit, _magazineData] call CFUNC(addMagazine);
    _unit addWeapon _className;
};
