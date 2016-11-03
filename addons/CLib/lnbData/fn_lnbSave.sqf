#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas, NetFusion

    Description:
    Save Data for lnb Data

    Parameter(s):
    0: Controll or IDC from Dialog <Number, Controll>
    1: Row and Colum <Array<Number>>
    2: Data that will saved <Any>

    Returns:
    None
*/
params ["_control", "_rowAndColumn", "_data"];

private _index = GVAR(lnbDataControlCache) pushBack _control;
GVAR(lnbDataDataCache) setVariable [str _index, _data];
_control lnbSetValue [_rowAndColumn, _index];
