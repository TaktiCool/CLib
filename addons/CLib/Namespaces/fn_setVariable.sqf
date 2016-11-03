#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Set variable on a namespace/logic/object and save the name to get it back from CFUNC(allVariables)

    Parameter(s):
    0: Namespace to set variable on <Namespace>
    1: Variable name <String>
    2: Variable content <Any>
    3: Cache name <String> (default: QGVAR(allVariableCache))
    4: Global <Bool> (default: false)

    Remark:
    4: Is ignored if namespace is a location

    Returns:
    None
*/
params ["_namespace", "_varName", "_varContent", ["_cacheName", QGVAR(allVariableCache)], ["_global", false, [false]]];

private _cache = [_namespace, _cacheName, []] call CFUNC(getVariable);
if (isNil "_varContent") then {
    private _index = _cache find _varName;
    if (_index != -1) then {
        _cache deleteAt _index;
    };
} else {
    _cache pushBackUnique _varName;
};

if (_namespace isEqualType locationNull) then {
    _namespace setVariable [_varName, _varContent];
    _namespace setVariable [_cacheName, _cache];
} else {
    _namespace setVariable [_varName, _varContent, _global];
    _namespace setVariable [_cacheName, _cache, _global];
};
