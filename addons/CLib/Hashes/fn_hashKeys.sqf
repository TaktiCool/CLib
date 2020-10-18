#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Returns all Keys Contained in Hashset

    Parameter(s):
    0: HashSet <Array> (Default: [[], []])

    Returns:
    All Keys from Hash <Array>
*/

params [["_hashSet", HASH_NULL, [[]]]];

[] + _hashSet select HASH_KEYS;
