#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Returns all loadouts

    Parameter(s):
    None

    Returns:
    Array With all Loadout Names <Array>
*/

([GVAR(loadoutsNamespace), QGVAR(allLoadouts)] call CFUNC(allVariables)) apply {
    _x select [18];
};
