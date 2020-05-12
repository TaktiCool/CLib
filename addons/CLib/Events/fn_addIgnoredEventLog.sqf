#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Adds events that do not get logged

    Parameter(s):
    0: Name <String> (Default: "")
    1: Ignore type <Number> (Default: 0)

    Returns:
    None

    Remarks:
    Ignore type:
        0 = do not log anything
        1 = do not log the arguments
*/

params [
    ["_name", "", [""]],
    ["_state", 0, [0]]
];

#ifndef DEBUGFULL
    switch (_state) do {
        case 0: {
            GVAR(ignoredLogEventNames_0) pushBackUnique toLower _name;
        };
        case 1: {
            GVAR(ignoredLogEventNames_1) pushBackUnique toLower _name;
        };
    };
#endif
