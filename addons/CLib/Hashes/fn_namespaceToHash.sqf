#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:


    Parameter(s):


    Returns:

*/
params ["_namespace", "_hash", ["_allVarName", ""]];
private _allVar = if (_allVarName == "") then {
    allVariables _namespace;
} else {
    [_namespace, _allVarName] call CFUNC(allVariables);
};

{
    private _var = _namespace getVariable _x;
    if !(isNil "_var") then {
        [_hash, _x, _var] call CFUNC(setHash);
    };
    nil
} count _allVar;
