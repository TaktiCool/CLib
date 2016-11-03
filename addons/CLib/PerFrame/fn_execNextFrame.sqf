#include "macros.hpp"
/*
    Community Lib - CLib

    Author: esteldunedain ported by joko // Jonas

    Description:
    Execture a Code on the Next Frame

    Parameter(s):
    0: Code to execute <Code>
    1: Parameters to run the code with <Array>

    Returns:
    None
*/
params [["_func",{}], ["_params", []]];

if (diag_frameno == GVAR(nextFrameNo)) then {
    GVAR(nextFrameBufferB) pushBack [_params, _func];
} else {
    GVAR(nextFrameBufferA) pushBack [_params, _func];
};
Nil
