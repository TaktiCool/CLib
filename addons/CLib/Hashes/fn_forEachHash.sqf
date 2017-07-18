#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:


    Parameter(s):


    Returns:

*/
params ["_hash", "_code", "_args"];

{
    private _key = _x;
    private _value = (_hash select HASK_VALUE) select _forEachIndex;
    [_key, _value, _args] call _code;
    nil
} forEach (_hash select HASH_KEY);
