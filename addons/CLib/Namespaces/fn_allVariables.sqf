#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Return allVariables that have been set with CFUNC(setVariable) of a namespace

    Parameter(s):
    0: Namespace <Namespace>
    1: Cache name <String> (default: QGVAR(allVariableCache))

    Returns:
    All variable names <Array>
*/
params ["_namespace", ["_cacheName", QGVAR(allVariableCache)]];

[_namespace, _cacheName, []] call CFUNC(getVariable);
