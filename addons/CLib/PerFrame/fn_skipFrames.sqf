#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Skip a amount of Frames and Execute After that Code

    Parameter(s):
    0: Code that get Executed if the Conditon is True <Code>
    1: Frames to Skip <Number>
    2: Paramter <Any>


    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED

params [["_code", {}], ["_frames", 0], ["_args", []]];
GVAR(skipFrameArray) pushBack [_frames + diag_frameNo, _code, _args];
GVAR(sortSkipFrameArray) = true;
