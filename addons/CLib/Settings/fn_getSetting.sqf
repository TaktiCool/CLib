#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Get a settings value

    Parameter(s):
    0: path <STRING>
    0: default value <SCALAR|STRING|ARRAY> (Depends on the Setting)

    Returns:
    <SCALAR|STRING|ARRAY> (Depends on the Setting)
*/
params [["_path",""], ["_defaultValue", nil]];
(GVAR(allSettings) getVariable [_path, [_defaultValue]]) select 0;
