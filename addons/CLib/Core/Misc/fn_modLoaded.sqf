#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if a Mod or Parts of it are Loaded

    Parameter(s):
    0: Mod Name <String> (Default: "")

    Returns:
    Mod is Loaded <Bool>
*/

params [
    ["_mod", "", [""]]
];

private _loadedMods = [];
{
    _loadedMods pushBackUnique ((_x splitString "/\") select 0);
} forEach GVAR(LoadedModules);
(toLowerANSI _mod) in _loadedMods;
