#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Copies gear from source unit to destination

    Parameter(s):
    0: Source Unit <Object> (Default: objNull)
    1: Destination Unit <Object> (Default: objNull)

    Returns:
    None
*/

params [
    ["_unit1", objNull, [objNull]],
    ["_unit2", objNull, [objNull]]
];

removeAllAssignedItems _unit2;
removeAllWeapons _unit2;
removeHeadgear _unit2;
removeGoggles _unit2;

[_unit2, _unit1 call CFUNC(saveGear)] call CFUNC(restoreGear);
