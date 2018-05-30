#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if a Hashset Contains a Key

    Parameter(s):
    0: HashSet <Array> (Default: [[], []])
    1: Key <Anything> (Default: "")

    Returns:
    Contains Key in Hash set <Bool>
*/

params [
    ["_hashSet", [[], []], [[]], 2],
    ["_key", "", []]
];

_key in (_hashSet select HASH_KEYS);
