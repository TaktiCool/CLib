#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if a Hashset Contains a Value

    Parameter(s):
    0: HashSet <Array> (Default: [[], []])
    1: Value <Anything>

    Returns:
    Contains Value in Hash set <Bool>
*/

params [
    ["_hashSet", [[], []], [[]]],
    "_value"
];

_value in (_hashSet select HASH_VALUES);
