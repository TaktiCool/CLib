#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: BadGuy

    Description:
    Adds a Status Effect Type to the System

    Parameter(s):
    0: Status Effect ID <String>
    1: Executed Code <Code>

    Returns:
    None
*/
params [["_id",""], ["_code",{}]];

if (_id == "") exitWith {};

GVAR(StatusEffectsNamespace) setVariable [("Code_" + _id), _code];
