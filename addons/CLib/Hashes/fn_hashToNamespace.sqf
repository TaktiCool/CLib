#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Converts a hash to a Namespace

    Parameter(s):
    0: Namespace <Location, Namespace, Object, Group> (Default: locationNull)
    1: HashSet <Array> (Default: [[], []])
    2: Publish Variables <Bool> (Default: false)
    3: AllVarNames Cache <String> (Default: EGVAR(Namespaces,allVariableCache))

    Returns:
    None
*/

params [
    ["_namespace", locationNull, [locationNull, missionNamespace, objNull, grpNull]],
    ["_hashSet", HASH_NULL, [[]]],
    ["_public", false, [true]],
    ["_allVarName", EGVAR(Namespaces,allVariableCache), [""]]
];

[_hashSet, {
    params ["_key", "_value", "_args"];
    _args params ["_namespace", "_public"];
    if (_key isEqualType "") then {
        [_namespace, _key, _value, _allVarName, _public] call CFUNC(setVariable);
    };
}, [_namespace, _public, _allVarName]] call CFUNC(forEachHash);
