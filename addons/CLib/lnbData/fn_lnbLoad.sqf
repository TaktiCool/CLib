#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas, NetFusion

    Description:
    Save Data from lnb Data

    Parameter(s):
    0: Control or IDC from dialog <Number, Control>
    1: Row and column <Array>

    Returns:
    Variable from lnbData <Any>
*/

params ["_control", "_rowAndColumn"];

private _index = _control lnbValue _rowAndColumn;
GVAR(lnbDataDataCache) getVariable (str _index);
