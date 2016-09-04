#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: joko // Jonas

    Description:
    check if a String is Localised

    Parameter(s):
    0: Localisation Name <String>

    Returns:
    is Localised <Bool>
*/
params [["_locaName", "STR_PRA3_ERROR"]];
private _temp = LVAR(ClientNamespace) getVariable _locaName;

!isNil "_temp";
