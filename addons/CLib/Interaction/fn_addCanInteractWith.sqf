#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add a canInteractWith condition

    Parameter(s):
    0: Type <String> (Default: "")
    1: Conditions <Code> (Default: {})

    Returns:
    None
*/
if (isNil QGVAR(canInteractWithTypes)) exitWith {
    GVAR(canInteractWithTypes) = [_this];
};
GVAR(canInteractWithTypes) pushBackUnique _this;
nil
