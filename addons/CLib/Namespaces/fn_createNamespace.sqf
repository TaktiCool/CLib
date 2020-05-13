#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Create a Location

    Parameter(s):
    0: Global <Anything> (Default: false)

    Returns:
    Namespace <Location, Object>

    Example:
    -
*/

params [
    ["_isGlobal", false, []]
];

if !(_isGlobal isEqualType true) then {
    _isGlobal = false;
};

#define POS [-2000, -2000, -2000]

private _ret = if (_isGlobal) then {
    createSimpleObject ["A3\Weapons_F\empty.p3d", POS];
} else {
    createLocation ["fakeTown", POS, 0, 0];
};

if (isNil QGVAR(allCustomNamespaces)) then {
    GVAR(allCustomNamespaces) = [];
};
GVAR(allCustomNamespaces) pushBack _ret;

_ret
