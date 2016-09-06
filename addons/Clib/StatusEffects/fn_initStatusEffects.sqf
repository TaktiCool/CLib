#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: BadGuy

    Description:
    Initialize Status Effect System

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(StatusEffectsNamespace) = call EFUNC(Core,createNamespace);

["forceWalk", {
    params ["_allParameters"];
    Clib_Player forceWalk (true in _allParameters);
}] call CFUNC(addStatusEffectType)
