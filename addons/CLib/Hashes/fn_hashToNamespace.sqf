#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:


    Parameter(s):


    Returns:

*/
params ["_namespace", "_hash", ["_public", false], ["_allVarName", ""]];
[_hash, {
    params ["_key", "_value", "_args"];
    _args params ["_namespace", "_public"];
    if (_key isEqualType "") then {
        [_namespace, _key, _value, _allVarName, _public] call CFUNC(setVariable);
    };
}, [_namespace, _public, _allVarName]] call CFUNC(forEachHash);
