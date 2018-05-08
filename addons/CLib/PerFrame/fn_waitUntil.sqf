#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Waits until a condition is true

    Parameter(s):
    0: Code that get executed if the conditon is true <Code> (Default: {})
    1: Conditon that get executed every frame <Code> (Default: {})
    2: Paramter <Anything> (Default: [])

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_callback", {}, [{}]],
    ["_condition", {}, [{}]],
    ["_args", [], []]
];

GVAR(waitUntilArray) pushBack [_callback, _condition, _args];
