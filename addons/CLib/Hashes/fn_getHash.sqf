#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Get a Value from the Hashset

    Parameter(s):
    0: HashSet <Array>
    1: Key <Anything>
    2: Default Value <Anything>

    Returns:
    Value from Hashset <Anything>
*/
params ["_hashSet", "_key", "_default"];

private _i = (_hashSet select HASH_KEY) find _key;
if (_i == -1) exitWith {
    _default
};
(_hashSet select HASH_VALUE) select _i;
