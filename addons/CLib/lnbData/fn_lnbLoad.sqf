#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas, NetFusion

    Description:
    Save Data from lnb Data

    Parameter(s):
    0: Control from dialog <Control> (Default: controlNull)
    1: Row and column <Array> (Default: [0, 0])

    Returns:
    Variable from lnbData <Anything>
*/

params [
    ["_control", controlNull, [controlNull]],
    ["_rowAndColumn", [0, 0], [[]], 2]
];

private _index = _control lnbValue _rowAndColumn;
_control getVariable (str _index);
