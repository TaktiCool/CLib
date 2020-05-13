#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Override a vanilla action

    Parameter(s):
    0: ActionName <String> (Default: "")
    1: Code <Code> (Default: {})
    2: Arguments <Anything> (Default: [])

    Returns:
    None
*/

params [
    ["_actionName", "", [""]],
    ["_code", {}, [{}]],
    ["_arguments", [], []]
];

[GVAR(InGameUIEventHandler), format ["Action_%1", _actionName], [_code, _arguments]] call CFUNC(setVariable);
