#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add weapon Wraper

    Parameter(s):
    0: Weapon Classname <String>
    1: Magazine Classname <String>
    2: Magazine count <Number>

    Returns:
    None
*/
params ["_unit", "_className", "_magazineData"];

if (_className != "") then {
    [_unit, _magazineData] call CFUNC(addMagazine);
    _unit addWeapon _className;
};
