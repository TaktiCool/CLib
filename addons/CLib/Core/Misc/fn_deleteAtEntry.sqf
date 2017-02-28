#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Deletes an entry out of an array

    Parameter(s):
    0: Array reference <Array>
    1: Entry to delete <Any>
    2: Delete every entry <Bool>(default: false)

    Remarks:
    This function works with the given reference!

    Returns:
    Deleted Index <Array<Numbers>>
*/

EXEC_ONLY_UNSCHEDULED

params ["_array", "_entry", ["_deleteAll", false]];

if (_deleteAll) exitWith {
    private _index = 0;
    private _return = [];
    while {_index = _array find _entry; _index != -1} do {
        _array deleteAt _index;
        _return pushBack _index;
    };
    _return
};

private _index = _array find _entry;
if (_index != -1) exitWith {
    _array deleteAt _index;
    [_index]
};
[]
