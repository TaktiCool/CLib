#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if a Hashset Contains a Key

    Parameter(s):
    0: HashSet <Array>
    1: Key <Anything>

    Returns:
    Contains Key in Hash set <Boolean>
*/
params ["_hashSet", "_key"];

_key in (_hashSet select HASH_KEY);
