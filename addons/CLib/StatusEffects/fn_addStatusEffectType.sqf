#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Adds a Status Effect Type to the system

    Parameter(s):
    0: Status effect id <String> (Default: "")
    1: Executed code <Code> (Default: {})

    Returns:
    None
*/

params [
    ["_id", "", [""]],
    ["_code", {}, [{}]]
];

if (_id == "") exitWith {
    LOG("Invalid id passed to addStatusEffectType");
};

if (_code isEqualTo {}) exitWith {
    LOG("Empty code passed to addStatusEffectType");
};

GVAR(StatusEffectsNamespace) set [QGVAR(Code_) + _id, _code];
