#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Deletes an entry out of an array

    Parameter(s):
    0: Array reference <Array> (Default: [])
    1: Entry to delete <Anything>
    2: Delete every entry <Bool> (Default: false)

    Returns:
    Deleted Index <Array>

    Remarks:
    This function works with the given reference!
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_array", [], [[]], []],
    "_entry",
    ["_deleteAll", false, [true]]
];

private "_index";
private _return = [];
if (_deleteAll) then {
    while {_index = _array find _entry; _index != -1} do {
        _array deleteAt _index;
        _return pushBack _index;
    };
} else {
    _index = _array find _entry;
    if (_index != -1) then {
        _array deleteAt _index;
    };
    _return pushBack _index;
};
_return
