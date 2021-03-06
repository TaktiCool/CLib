#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Get all settings of a settings-path

    Parameter(s):
    0: Path <String> (Default: "")

    Returns:
    Array of strings <Array>
*/

params [
    ["_path", "", [""]]
];

GVAR(allSettings) getVariable ["SETTINGS:" + _path, []];
