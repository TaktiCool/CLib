#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Returns all variables that have been set on a namespace with our setVariable function

    Parameter(s):
    0: Namespace <Namespace>
    1: Cache name <String> (Default: QGVAR(allVariableCache))

    Returns:
    All variable names <Array>
*/

params ["_namespace", ["_cacheName", QGVAR(allVariableCache)]];
_namespace getVariable [_cacheName, []];
