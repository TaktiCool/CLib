#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Skip a amount of Frames and Execute After that Code

    Parameter(s):
    0: Code that get executed if the conditon is true <Code> (Default: {})
    1: Number of frames to skip <Number> (Default: 0)
    2: Paramter <Anything> (Default: [])

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED

params [
    ["_code", {}, [{}]],
    ["_frames", 0, [0]],
    ["_args", [], []]
];

GVAR(skipFrameArray) pushBack [_frames + diag_frameNo, _code, _args];
GVAR(sortSkipFrameArray) = true;
