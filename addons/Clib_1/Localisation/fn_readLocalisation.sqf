#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    Read the Localisation if the String is Localised

    Parameter(s):
    0: Localisation Name <String>

    Returns:
    Localisted Text <String>
*/
params [["_locaName", "STR_CLib_ERROR"]];
[LVAR(ClientNamespace), _locaName, "Error"] call CFUNC(getVariable);
