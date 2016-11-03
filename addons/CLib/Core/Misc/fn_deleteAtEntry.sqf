#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Delete a entry out of a Array

    Parameter(s):
    0: Array Reference <Array>
    1: Entry to Delete <Any>
    2: delete Every Entry <Bool>(default: false)

    Remarks:
    This function work with the Reference!

    Returns:
    Deleted Index <Array<Numbers>>
*/

params ["_array", "_entry", ["_deleteAll", false]];
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
