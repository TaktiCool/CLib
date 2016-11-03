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

params ["_u1"];

[[_u1] call CFUNC(getAllGear), magazinesAmmoFull _u1]
