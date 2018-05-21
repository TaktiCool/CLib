#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Converts a Namespace into a Hash

    Parameter(s):
    0: Namespace <Object, Location>
    1: HashSet <Array>
    2: AllVarNames Cache <String>

    Returns:
    None
*/
params ["_namespace", "_hashSet", ["_allVarName", ""]];
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
