#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas, NetFusion

    Description:
    Returns a shuffled array.

    Parameter(s):
    0: Array <Array> (Default: [])

    Returns:
    Shuffled array <Array>
*/

_arr = +_this;
private _res = [];
for "_i" from count _arr to 1 step -1 do {
    _res pushBack (_arr deleteAt floor random _i);
};
_res append _arr;
_res
