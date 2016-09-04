#include "macros.hpp"
/*
    Project Reality ArmA 3

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
params ["_className", "_magazine", "_count"];

if (_className != "") then {
    [_magazine, _count] call FUNC(addMagazine);
    Clib_Player addWeapon _className;
};
