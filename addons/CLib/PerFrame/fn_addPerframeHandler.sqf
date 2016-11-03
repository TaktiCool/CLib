#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    add a Perframe eventhandler

    Parameter(s):
    0: Function that get called <Code, String>
    1: Delay <Number>
    2: Arguments <Any>

    Remarks:
    Never call This in scheduled Environment

    Returns:
    None
*/
[{
    params [["_function", {}, [{},""]], ["_delay", 0, [0]], ["_args", []]];

    if (_function isEqualTo {}) exitWith {-1};

    if (count GVAR(PFHhandles) >= 999999) exitWith {
        diag_log _function;
        -1
    };

    private _handle = GVAR(PFHhandles) pushBack count GVAR(perFrameHandlerArray);

    GVAR(perFrameHandlerArray) pushBack [_function, _delay, time, time, _args, _handle];

    _handle
}, _this] call CFUNC(directCall);
