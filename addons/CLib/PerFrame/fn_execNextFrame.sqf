#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: esteldunedain
    https://github.com/CBATeam/CBA_A3/blob/efa4ee3b13cc6cbf8919656ca847047c12d057e0/addons/common/fnc_execNextFrame.sqf

    Description:
    Execture a Code on the Next Frame

    Parameter(s):
    0: Code to execute <Code> (Default: {})
    1: Parameters to run the code with <Anything> (Default: [])

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_func", {}, [{}]],
    ["_params", [], []]
];

if (diag_frameNo == GVAR(nextFrameNo)) then {
    GVAR(nextFrameBuffer) pushBack [_params, _func];
} else {
    GVAR(currentFrameBuffer) pushBack [_params, _func];
};
