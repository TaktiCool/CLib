#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if a Module is Loaded

    Parameter(s):
    0: Module Name <String> (Default: "")

    Returns:
    Module is Loaded <Bool>
*/

params [
    ["_module", "", [""]]
];

toLower(_module) in GVAR(LoadedModules);
