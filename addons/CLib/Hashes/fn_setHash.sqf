#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:


    Parameter(s):


    Returns:

*/
params ["_hash", "_key", "_value"];

private _delete = isNil "_value";

private _contain = [_hash, _key] call CFUNC(containsKey);

switch (true) do {
    case (_contain && _delete): {
        private _i = (_hash select HASH_KEY) find _key;
        {
            _x deleteAt _i;
            nil
        } count _hash;
        _hash
    };
    case (_contain && !_delete): {
        private _i = (_hash select HASH_KEY) find _key;
        (_hash select HASH_VALUE) set [_i, _value];
        _hash
    };
    case (!_contain && !_delete): {
        private _i = (_hash select HASH_KEY) pushBack _key;
        (_hash select HASH_VALUE) set [_i, _value];
        _hash
    };
    default {
        DUMP("ERROR: Something went wrong");
    };
};
