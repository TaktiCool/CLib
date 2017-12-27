#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Save Gear

    Parameter(s):
    0: Source Unit <Object>

    Returns:
    None
*/

params ["_unit"];

[[_unit] call CFUNC(getAllGear), magazinesAmmoFull _unit]
