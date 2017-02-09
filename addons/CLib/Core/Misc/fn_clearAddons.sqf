#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    clears a array of AddonNames and Version of a ignoredNames array

    Parameter(s):
    0: Addons <Array>
        0: Names <Array of Strings>
        1: Versions <Array of Array Numbers>
    1:

    Returns:
    None
*/

params ["_addons", "_ignore"];

_addons params ["_names", "_versions"];
{
    if (_x in _ignore) then {
        _names set [_forEachIndex, objNull];
        _versions set [_forEachIndex, objNull];
    };
} forEach _names;

_names = _names - [objNull];
_versions = _versions - [objNull];

[_names, _versions]
