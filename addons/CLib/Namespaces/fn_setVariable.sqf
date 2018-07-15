#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Sets a variable on a namespace and saves the name of the variable

    Parameter(s):
    0: Namespace to set variable on <Location, Namespace, Object> (Default: locationNull)
    1: Variable name <String> (Default: "")
    2: Variable content <Anything> (Default: nil)
    3: Cache name <String> (Default: QGVAR(allVariableCache))
    4: Global <Bool> (Default: false)

    Returns:
    None

    Remarks:
    Global parameter is ignored if namespace is of type location
*/

params [
    ["_namespace", locationNull, [locationNull, missionNamespace, objNull]],
    ["_varName", "", [""]],
    "_varContent",
    ["_cacheName", QGVAR(allVariableCache), [""]],
    ["_global", false, [true]]
];

private _cache = _namespace getVariable [_cacheName, []];
if (isNil "_varContent") then {
    private _index = _cache find _varName;
    if (_index != -1) then {
        _cache deleteAt _index;
    };
} else {
    _cache pushBackUnique _varName;
};

if (_namespace isEqualType locationNull) then {
    // we need to check our self if varContent is Nil else BI throws a error
    if (isNil "_varContent") then {
        _namespace setVariable [_varName, nil];
    } else {
        _namespace setVariable [_varName, _varContent];
    };
    _namespace setVariable [_cacheName, _cache];
} else {
    // we need to check our self if varContent is Nil else BI throws a error
    if (isNil "_varContent") then {
        _namespace setVariable [_varName, nil, _global];
    } else {
        _namespace setVariable [_varName, _varContent, _global];
    };
    _namespace setVariable [_cacheName, _cache, _global];
};
