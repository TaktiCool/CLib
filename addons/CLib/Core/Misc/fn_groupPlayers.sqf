#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Gets all Players of a group. Compareable to 'units' command.

    Remark:
    None

    Parameter(s):
    0: group or unit

    Returns:
    0: array of units <Array>
*/
params ["_group"];

(units _group) select {_x in allPlayers};
