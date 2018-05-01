#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Description

    Parameter(s):
    ID <Number>

    Returns:
    All SimpleObjects <Array<Objects>>
*/
if !(isServer) exitWith {
    [QGVAR(deleteSimpleObjectComp), _this] call CFUNC(serverEvent);
};

params ["_id"];

{
    deleteVehicle _x;
    nil
} count (GVAR(simpleObjectComps) select _id);
GVAR(simpleObjectComps) set [_id, nil];
nil
