#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Loops Though all Entrys in a HashSet

    Parameter(s):
    0: HashSet <Array> (Default: [[], []])
    1: Code to Execute on every Items of the Hash set <Code> (Default: {})
    2: Arguments that get Passed to the Code <Anything> (Default: [])

    Returns:
    None
*/

params [
    ["_hashSet", HASH_NULL, [[]]],
    ["_code", {}, [{}]],
    ["_args", [], []]
];

{
    private _key = _x;
    private _value = (_hashSet select HASH_VALUES) select _forEachIndex;
    [_key, _value, _args] call _code;
} forEach (_hashSet select HASH_KEYS);
