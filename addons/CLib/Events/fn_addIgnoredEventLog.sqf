#include "macros.hpp"
/*
    Community Lib - CLib

    Author: Author

    Description:
    Add Event that dont get Logged

    Parameter(s):
    0: Name <String>
    1: ignore Type <Number>
        0 = dont Log anything
        1 = dont log the Aruments

    Returns:
    None
*/
params ["_name", ["_state", 0]];
#ifndef DEBUGFULL
switch (_state) do {
    case (0): {
        GVAR(ignoredLogEventNames_0) pushBackUnique toLower(_name);
    };
    case (1): {
        GVAR(ignoredLogEventNames_1) pushBackUnique toLower(_name);
    };
};
#endif
