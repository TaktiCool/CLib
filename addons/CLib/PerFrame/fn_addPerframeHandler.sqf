#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Adds a PerFrame eventhandler

    Parameter(s):
    0: Function that get called <Code, String> (Default: {})
    1: Delay <Number> (Default: 0)
    2: Arguments <Anything> (Default: [])

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED

params [
    ["_function", {}, [{}, ""]],
    ["_delay", 0, [0]],
    ["_args", [], []]
];

if (_function isEqualTo {}) exitWith {-1};

if (count GVAR(PFHhandles) >= 999999) exitWith {
    LOG("ERROR: Could not add more PFH. Max count from 999999 where exceeded");
    -1
};

private _handle = GVAR(PFHhandles) pushBack count GVAR(perFrameHandlerArray);

GVAR(perFrameHandlerArray) pushBack [_function, _delay, time, _args, _handle];

_handle
