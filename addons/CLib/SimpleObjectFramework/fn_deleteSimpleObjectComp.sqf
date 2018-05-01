#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Description

    Parameter(s):
    UID <String>

    Returns:

*/
if !(isServer) exitWith {
    [QGVAR(deleteSimpleObjectComp), _this] call CFUNC(serverEvent);
};

params ["_uid"];
private _objs = GVAR(compNamespace) getVariable [_uid, []];
{
    deleteVehicle _x;
    nil
} count _objs;
GVAR(compNamespace) setVariable [_uid, nil, true];
nil
