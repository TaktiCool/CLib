#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Get an object from an object pool

    Parameter(s):
    0: Requested object type <String> (Default: "")
    1: Time to be locked after use <Number> (Default: 10)
    2: Should the object be local <Bool> (Default: true)

    Returns:
    Requested Object <Object>
*/

params [
    ["_objClass", "", [""]],
    ["_lockingTime", 10, [0]],
    ["_local", true, [true]]
];

private _varName = [_objClass, _objClass + "_local"] select _local;

private _objsData = GVAR(objPool) getVariable [_varName, [[-999, objNull]]];
private _data = _objsData select 0;
_data params ["_time", "_obj"];
if (!alive _obj || _time >= time) then {
    if (_local) then {
        _obj = _objClass createVehicleLocal [0, 0, 0];
    } else {
        _obj = _objClass createVehicle [0, 0, 0];
    };
} else {
    _objsData deleteAt 0;
};
_objsData pushBack [time + _lockingTime, _obj];
_objsData sort true;
GVAR(objPool) setVariable [_varName, _objsData, !_local];
_obj
