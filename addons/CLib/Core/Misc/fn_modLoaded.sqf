#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if a Mod or Parts of it are Loaded

    Parameter(s):
    0: Mod Name <String>

    Returns:
    Mod is Loaded <Bool>
*/
params ["_mod"];
private _loadedMods = [];
{
    _loadedMods pushbackUnique ((_x splitString "/\") select 0);
    nil
} count GVAR(LoadedModules);
_mod in _loadedMods;
