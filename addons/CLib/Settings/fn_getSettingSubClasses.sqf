#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Get all subclasses of settings-path

    Parameter(s):
    0: path <STRING>

    Returns:
    <ARRAY> (Array of strings)
*/
params [["_path", ""]];
GVAR(allSettings) getVariable ["CLASSES:" + _path, []];
