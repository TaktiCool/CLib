#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Converts a Namespace into a Hash

    Parameter(s):
    0: Namespace <Location, Namespace, Object, Group> (Default: locationNull)
    1: HashSet <Array> (Default: [[], []])
    2: AllVarNames Cache <String> (Default: EGVAR(Namespaces,allVariableCache))

    Returns:
    None
*/

params [
    ["_namespace", locationNull, [locationNull, missionNamespace, objNull, grpNull]],
    ["_hashSet", [[], []], [[]]],
    ["_allVarName", EGVAR(Namespaces,allVariableCache), [""]]
];

private _allVar = if (_allVarName == "") then {
    allVariables _namespace;
} else {
    [_namespace, _allVarName] call CFUNC(allVariables);
};

{
    private _var = _namespace getVariable _x;
    if !(isNil "_var") then {
        [_hashSet, _x, _var] call CFUNC(setHash);
    };
    nil
} count _allVar;

_hashSet
