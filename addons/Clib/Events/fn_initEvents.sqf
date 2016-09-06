#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: joko // Jonas

    Description:
    init for Events

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(EventNamespace) = call EFUNC(Core,createNamespace);

["hideObject", {
    (_this select 0) params ["_object", "_value"];
    _object hideObjectGlobal _value;
}] call FUNC(addEventhandler);
["enableSimulation", {
    (_this select 0) params ["_object", "_value"];
    _object enableSimulationGlobal _value;
}] call FUNC(addEventhandler);
["forceWalk", {
    (_this select 0) params ["_object", "_value"];
    _object forceWalk _value;
}] call FUNC(addEventHandler);
["blockSprint", {
    (_this select 0) params ["_object", "_value"];
    _object allowSprint !_value;
}] call FUNC(addEventHandler);
["fixFloating", {
    (_this select 0) params ["_object"];
    [_object] call FUNC(fixFloating);
}] call FUNC(addEventHandler);
["fixFloating", {
    (_this select 0) params ["_object"];
    [_object] call FUNC(fixFloating);
}] call FUNC(addEventHandler);
["fixPosition", {
    (_this select 0) params ["_object"];
    [_object] call FUNC(fixPosition);
}] call FUNC(addEventHandler);
["setCaptive", {
    (_this select 0) params ["_object", "_value"];
    _object setCaptive _value;
}] call FUNC(addEventHandler);
["blockDamage", {
    (_this select 0) params ["_object", "_value"];
    _object allowDamage !_value;
}] call FUNC(addEventHandler);
["deleteGroup", {
    (_this select 0) params ["_group"];

    if (isServer && !(isNull _group) && !(local _group)) exitWith {
        ["deleteGroup", groupOwner _group, _group] call FUNC(targetEvent);
    };

    deleteGroup _group;
}] call FUNC(addEventHandler);
["selectLeader", {
    (_this select 0) params ["_group", "_unit"];

    if (isServer && !(isNull _group) && !(local _group)) exitWith {
        ["selectLeader", groupOwner _group, [_group, _unit]] call FUNC(targetEvent);
    };
    _group selectLeader _unit;
}] call FUNC(addEventHandler);
["switchMove", {
    (_this select 0) params ["_unit", "_move"];
    _unit switchmove _move;
}] call FUNC(addEventHandler);
["setVectorDirAndUp", {
    (_this select 0) params ["_obj", "_pos"];
    _obj setVectorDirAndUp _pos;
}] call FUNC(addEventHandler);
["missionStarted", {
    GVAR(missionStartedTriggered) = true;
}] call FUNC(addEventHandler);
["moveInCargo", {
    (_this select 0) params ["_vehicle", "_unit"];
    if (!(local _vehicle) && !(isNull _vehicle)) exitWith {
        ["moveInCargo", _vehicle, [_vehicle, _unit]] call CFUNC(targetEvent);
    };
    _unit moveInCargo _vehicle;
}] call FUNC(addEventHandler);
["moveInDriver", {
    (_this select 0) params ["_vehicle", "_unit"];
    if (!(local _vehicle) && !(isNull _vehicle)) exitWith {
        ["moveInDriver", _vehicle, [_vehicle, _unit]] call CFUNC(targetEvent);
    };
    _unit moveInDriver _vehicle;
}] call FUNC(addEventHandler);
["moveInTurret", {
    (_this select 0) params ["_vehicle", "_unit", "_turretPath"];
    if (!(local _vehicle) && !(isNull _vehicle)) exitWith {
        ["moveInTurret", _vehicle, [_vehicle, _unit, _turretPath]] call CFUNC(targetEvent);
    };
    _unit moveInTurret [_vehicle, _turretPath];
}] call FUNC(addEventHandler);

GVAR(entities) = [];
[{

    private _entities = ((entities "") - allUnits) + allUnits;

    if !(_entities isEqualTo GVAR(entities)) then {
        {
            if !(_x getVariable [QGVAR(isProcessed), false] || _x isKindOf "Animal" || _x isKindOf "Logic") then {
                ["entityCreated", _x] call CFUNC(localEvent);
                _x setVariable [QGVAR(isProcessed), true];
            };
            nil
        } count (_entities - GVAR(entities));

        GVAR(entities) = _entities;
    };
}, 0.1, []] call FUNC(addPerFrameHandler);
