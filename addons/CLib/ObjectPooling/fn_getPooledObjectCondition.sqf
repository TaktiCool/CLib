#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Get an object from an object pool

    Parameter(s):
    0: Requested object type <String> (Default: "")
    1: Locked condition <Code> (Default: {false})
    2: Should the object be local <Bool> (Default: true)

    Returns:
    Requested Object <Object>
*/

params [
    ["_objClass", "", [""]],
    ["_condition", {false}, [{}]],
    ["_local", true, [true]]
];

private _varName = [_objClass + "_condition", _objClass + "_condition_local"] select _local;

private _objsData = GVAR(objPool) getVariable [_varName, [[-999, objNull]]];
private _object = objNull;
{
    _x params ["_lockedCondition", "_obj"];
    if (alive _obj && !(call _lockedCondition)) then {
        _objsData deleteAt _forEachIndex;
        _object = _obj;
        breakTo SCRIPTSCOPENAME;
    };
} forEach _objsData;

_objsData pushBack [_condition, _object];
GVAR(objPool) setVariable [_varName, _objsData, !_local];
_object
