#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if a Module is Loaded

    Parameter(s):
    0: Module Name <String>

    Returns:
    Module is Loaded <Bool>
*/
params ["_module"];

_module in GVAR(LoadedModules);
