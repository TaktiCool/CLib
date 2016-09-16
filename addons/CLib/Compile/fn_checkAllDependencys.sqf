#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    set to All Function a Dependency

    Parameter(s):
    None

    Returns:
    None
*/

{
    private _data = parsingNamespace getVariable _x + "_data";

    private _dependency = _x call CFUNC(checkDependency);
    _data set [3, _dependency];
    parsingNamespace setVariable [_x + "_data", _data];
} count CGVAR(functionCache);
