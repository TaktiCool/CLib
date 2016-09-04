#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: BadGuy

    Description:
    Save Gear

    Parameter(s):
    0: Source Unit <Object>

    Returns:
    None
*/

params ["_u1"];

[[_u1] call FUNC(getAllGear), magazinesAmmoFull _u1]
