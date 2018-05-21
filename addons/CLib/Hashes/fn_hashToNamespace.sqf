#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Converts a hash to a Namespace

    Parameter(s):
    0: Namespace <Object, Location>
    1: HashSet <Array>
    2: Publish Variables <Bool>
    3: AllVarNames Cache <String>

    Returns:
    None
*/
params ["_namespace", "_hashSet", ["_public", false], ["_allVarName", ""]];
[_hashSet, {
    params ["_key", "_value", "_args"];
    _args params ["_namespace", "_public"];
    if (_key isEqualType "") then {
        [_namespace, _key, _value, _allVarName, _public] call CFUNC(setVariable);
    };
}, [_namespace, _public, _allVarName]] call CFUNC(forEachHash);
