#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: joko // Jonas

    Description:
    Add magazine Wraper

    Parameter(s):
    0: Magazine Classname <String>
    1: Magazine count <Number>

    Returns:
    None
*/
params ["_className", "_count"];

if (_className != "" && _count > 0) then {
    for "_i" from 1 to _count do {
        Clib_Player addMagazine _className;
    };
};
