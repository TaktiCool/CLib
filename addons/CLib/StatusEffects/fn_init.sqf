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

GVAR(StatusEffectsNamespace) = createHashMap;

if (hasInterface) then {
    ["forceWalk", {
        params ["_unit", "_allParameters"];
        _unit forceWalk (true in _allParameters);
    }] call CFUNC(addStatusEffectType);

    ["allowDamage", {
        params ["_unit", "_allParameters"];
        _unit allowDamage !(false in _allParameters);
    }] call CFUNC(addStatusEffectType);
};
