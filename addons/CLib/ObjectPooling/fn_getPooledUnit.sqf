#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    try to get a Object from a Object Pool.

    Parameter(s):
    0: Requested Object Type <String>
    1: Time to be locked after use <Number>
    2: should the Object be Local <Bool>

    Returns:
    Requested Object <Object>
*/
params [["_unitClass", "", [""]], ["_lockedCondition", {}, [{}]], ["_unitParams", [[0,0,0], grpNull, "", 0.5, "PRIVATE"]]];

private _varName = _objClass + "_unit";

private _unitsData = GVAR(objPool) getVariable [_varName, [[-999, objNull]]];
private _unit = objNull;
{
    param ["_lockedCondition", "_obj"];
    if (alive _obj && !(call _lockedCondition)) then {
        _unitsData  _forEachIndex;
        _unit = _obj;
        breakTo SCRIPTSCOPENAME;
    };
} forEach _unitsData;
if (isNull _unit) then {
    _unit _unitClass createUnit _unitParams;
} else {
    _unitParams params ["_pos", "_grp", "_init", "_skill", "_rank"];
    _unit setPos _pos;
    [_unit] joinSilent _grp;
    
};

_unitsData pushBack [time + _lockingTime, _obj];
_objs sort true;
GVAR(objPool) setVariable [_varName, _unitsData, true];
_obj
