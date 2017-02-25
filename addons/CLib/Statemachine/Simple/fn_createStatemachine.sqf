#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Create a New Statemachine.

    Parameter(s):
    None

    Returns:
    Statemachine Object <Location>
*/

private _namespace = false call CFUNC(createNamespace);

_namespace setVariable [SMSVAR(nextStateData), "init"];
_namespace
