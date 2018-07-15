#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add a canInteractWith condition

    Parameter(s):
    0: Type <String> (Default: "")
    1: Condition <Code> (Default: {})

    Returns:
    None
*/

params [
    ["_type", "", [""]],
    ["_condition", {}, [{}]]
];

if (isNil QGVAR(canInteractWithTypes)) exitWith {
    GVAR(canInteractWithTypes) = [[_type, _condition]];
};
GVAR(canInteractWithTypes) pushBackUnique [_type, _condition];
nil
