#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Save Gear

    Parameter(s):
    0: Source Unit <Object> (Default: player)

    Returns:
    None
*/

params [
    ["_unit", player, [objNull]]
];

[[_unit] call CFUNC(getAllGear), magazinesAmmoFull _unit]
