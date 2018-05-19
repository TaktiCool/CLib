#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:


    Parameter(s):


    Returns:

*/
params ["_hash", "_key", "_default"];

private _i = (_hash select HASH_KEY) find _key;
if (_i == -1) exitWith {
    _default
};
(_hash select HASH_VALUE) select _i;
