#include "macros.hpp"
/*
    Project Reality ArmA 3

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
    PRA3_Player forceWalk (true in _allParameters);
}] call CFUNC(addStatusEffectType)
