#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Description

    Parameter(s):
    0: Unique identifier <String> (Default: "")

    Returns:
    None
*/

params [
    ["_uid", "", [""]]
];

if !(isServer) exitWith {
    [QGVAR(deleteSimpleObjectComp), _this] call CFUNC(serverEvent);
};

private _objs = GVAR(compNamespace) getVariable [_uid, []];
{
    deleteVehicle _x;
    nil
} count _objs;
GVAR(compNamespace) setVariable [_uid, nil, true];
