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
params ["_mod"];
private _loadedMods = [];
{
    _loadedMods pushbackUnique ((_x splitString "/\") select 0);
    nil
} count GVAR(LoadedModules);
_mod in _loadedMods;
