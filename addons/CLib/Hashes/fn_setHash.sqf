#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Sets a Hash Value to a Key in a Hashlist

    Parameter(s):
    0: HashSet <Array> (Default: [[], []])
    1: Key <Anything> (Default: "")
    2: Value <Anything>

    Returns:
    HashSet <Array>
*/

params [
    ["_hashSet", HASH_NULL, [[]]],
    ["_key", "", []],
    "_value"
];

private _delete = isNil "_value";

private _contain = [_hashSet, _key] call CFUNC(containsKey);

switch (true) do {
    case (_contain && _delete): {
        private _i = (_hashSet select HASH_KEYS) find _key;
        {
            _x deleteAt _i;
            nil
        } count _hashSet;
        _hashSet
    };
    case (_contain && !_delete): {
        private _i = (_hashSet select HASH_KEYS) find _key;
        (_hashSet select HASH_VALUES) set [_i, _value];
        _hashSet
    };
    case (!_contain && !_delete): {
        private _i = (_hashSet select HASH_KEYS) pushBack _key;
        (_hashSet select HASH_VALUES) set [_i, _value];
        _hashSet
    };
    case (!_contain && _delete): {
        _hashSet
    };
    default {
        DUMP("ERROR: Something went wrong");
        _hashSet
    };
};
