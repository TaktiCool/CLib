#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Gets all players of a group. Comparable to units command.

    Parameter(s):
    0: Group or unit <Group, Object> (Default: player)

    Returns:
    Units <Array>
*/

params [
    ["_group", player, [grpNull, objNull]]
];

(units _group) select {_x in allPlayers};
