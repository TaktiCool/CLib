#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Get a settings value

    Parameter(s):
    0: Path <String> (Default: "")
    1: Default value <Array, String, Number> (Default: nil)

    Returns:
    Setting value <Array, String, Number>
*/

params [
    ["_path", "", [""]],
    ["_defaultValue", nil, [[], "", 0], []]
];

(GVAR(allSettings) getVariable [_path, [_defaultValue]]) select 0
