#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init for Object Pooling

    Parameter(s):
    None

    Returns:
    None
*/

if (isServer) then {
    GVAR(objPool) = true call CFUNC(createNamespace);
};
