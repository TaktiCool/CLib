#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Create a Location

    Parameter(s):
    Is Global <Bool> (default: false)

    Returns:
    Namespace <Location>

    Example:
    -
*/

#define POS [-2000, -2000, -2000]

params [["_isGlobal", false]];

private _ret = if (_isGlobal isEqualType true && {_isGlobal}) then {
    createSimpleObject ["A3\Weapons_F\empty.p3d", POS];
} else {
    createLocation ["fakeTown", POS, 0, 0];
};

if (isNil QGVAR(allCustomNamespaces)) then {
    GVAR(allCustomNamespaces) = [];
};
GVAR(allCustomNamespaces) pushBack _ret;

_ret
