#include "macros.hpp"
/*
    Comunity Lib - CLib

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
    CLib_Player forceWalk (true in _allParameters);
}] call CFUNC(addStatusEffectType)
