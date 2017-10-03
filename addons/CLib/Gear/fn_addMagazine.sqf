#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add magazine Wraper

    Parameter(s):
    0: Magazine Classname <String>
    1: Magazine count <Number>

    Returns:
    None
*/
params ["_unit", "_magazineData"];
_magazineData params ["_className", ["_count", 1]];

if (_className != "" && _count > 0) then {
    for "_i" from 1 to _count do {
        _unit addMagazine _className;
    };
};
