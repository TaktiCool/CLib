#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Copies gear from source unit to destination

    Parameter(s):
    0: Source Unit <Object>
    1: Destination Unit <Object>

    Returns:
    None
*/

params ["_unit1", "_unit2"];

removeAllAssignedItems _unit2;
removeAllWeapons _unit2;
removeHeadgear _unit2;
removeGoggles _unit2;


[_unit2, _unit1 call CFUNC(saveGear)] call CFUNC(restoreGear);
