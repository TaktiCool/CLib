#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas, NetFusion

    Description:
    Save Data for lnb Data

    Parameter(s):
    0: Control from dialog <Control> (Default: controlNull)
    1: Row and column <Array> (Default: [0, 0])
    2: Data that will saved <Any> (Default: [])

    Returns:
    None
*/

params [
    ["_control", controlNull, [controlNull]],
    ["_rowAndColumn", [0, 0], [[]], 2],
    ["_data", [], []]
];

if (isNil QGVAR(index)) then {
    GVAR(index) = -1;
};
GVAR(index) = GVAR(index) + 1;
_control setVariable [str GVAR(index), _data];
_control lnbSetValue [_rowAndColumn, GVAR(index)];
