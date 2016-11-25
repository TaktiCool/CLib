#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Initialize Status Effect System

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(StatusEffectsNamespace) = call CFUNC(createNamespace);

["forceWalk", {
    params ["_allParameters"];
    CLib_Player forceWalk (true in _allParameters);
}] call CFUNC(addStatusEffectType)
