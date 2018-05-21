#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Sets a Value on to a Hash

    Parameter(s):
    0: HashSet <Array>
    1: Key <Anything>
    2: Value <Anything>

    Returns:
    None
*/
params ["_hashSet", "_key", "_value"];

private _delete = isNil "_value";

private _contain = [_hashSet, _key] call CFUNC(containsKey);

switch (true) do {
    case (_contain && _delete): {
        private _i = (_hashSet select HASH_KEY) find _key;
        {
            _x deleteAt _i;
            nil
        } count _hashSet;
        _hashSet
    };
    case (_contain && !_delete): {
        private _i = (_hashSet select HASH_KEY) find _key;
        (_hashSet select HASH_VALUE) set [_i, _value];
        _hashSet
    };
    case (!_contain && !_delete): {
        private _i = (_hashSet select HASH_KEY) pushBack _key;
        (_hashSet select HASH_VALUE) set [_i, _value];
        _hashSet
    };
    default {
        DUMP("ERROR: Something went wrong");
    };
};
