#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Returns all Values Contained in Hashset

    Parameter(s):
    0: HashSet <Array> (Default: [[], []])

    Returns:
    Is Hash <Bool>
*/

params ["_hashSet"];

_hashSet isEqualType []
&& {(count _hashSet) == 2}
&& {_hashSet isEqualTypeArray HASH_NULL}
&& {(count (_hashSet select HASH_KEYS)) isEqualTo (count (_hashSet select HASH_KEYS))}
