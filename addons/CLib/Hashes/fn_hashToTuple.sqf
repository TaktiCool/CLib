#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Returns all data Contained in the HashSet as Tuples

    Parameter(s):
    0: HashSet <Array> (Default: [[], []])

    Returns:
    HashSet data as Tuple Data <Array>
*/

params [["_hashSet", HASH_NULL, [[]]]];

private _tuple = [];

[_hashSet, {
    params ["_key", "_value"];
    _tuple pushBack [_key, _value];
}] call CFUNC(forEachHash);

_tuple;
