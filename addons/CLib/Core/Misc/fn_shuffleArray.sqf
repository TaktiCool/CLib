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

_this = +_this;
private _res = [];
for "_i" from count _this to 1 step -1 do {
    _res pushBack (_this deleteAt floor random _i);
};
_res append _this;
_res
