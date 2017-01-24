#include "macros.hpp"
/*
    Community Lib - CLib
    Author: joko // Jonas
    Description:
    Get all CfgPatches with Version Number
    Parameter(s):
    None
    Returns:
    0: Name of the Patches <String>
    1: Version of Mod <String>
*/

private _names = [];
private _version = [];
{
    _names pushBack configName _x;
    _version pushBack getArray (_x >> "versionAr");
    nil
} count configProperties [configFile >> "CfgPatches", "isClass _x", true];

[_names, _version]
