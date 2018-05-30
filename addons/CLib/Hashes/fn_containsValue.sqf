#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if a Hashset Contains a Value

    Parameter(s):
    0: HashSet <Array> (Default: [[], []])
    1: Value <Anything> (Default: objNull)

    Returns:
    Contains Value in Hash set <Bool>
*/

params [
    ["_hashSet", [[], []], [[]], 2],
    ["_value", objNull, []]
];

_value in (_hashSet select HASH_VALUES);
