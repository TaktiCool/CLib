#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas, NetFusion

    Description:
    Save Data for lnb Data

    Parameter(s):
    0: Control or IDC from dialog <Number, Control>
    1: Row and column <Array>
    2: Data that will saved <Any>

    Returns:
    None
*/
params ["_control", "_rowAndColumn", "_data"];

if (isNil QGVAR(index)) then {
    GVAR(index) = -1;
};
GVAR(index) = GVAR(index) + 1;
_control setVariable [str GVAR(index), _data];
_control lnbSetValue [_rowAndColumn, GVAR(index)];
