#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Wrapper for setVariable on namespaces

    Parameter(s):
    0: Object to set variable on <Namespace>
    1: Variable name <String>
    2: Variable content <Any>
    3: Global <Bool> (default: false)

    Remark:
    3: Is ignored if namespace is a location

    Returns:
    None
*/
params ["_namespace", "_varName", "_varContent", ["_global", false, [false]]];
if (_namespace isEqualType locationNull) then {
    _namespace setVariable [_varName, _varContent];
} else {
    _namespace setVariable [_varName, _varContent, _global];
};
