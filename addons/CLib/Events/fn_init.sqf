#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    init for Events

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(EventNamespace) = false call CFUNC(createNamespace);

GVAR(ignoredLogEventNames_0) = [];
GVAR(ignoredLogEventNames_1) = [];

{
    _x call CFUNC(addIgnoredEventLog);
    nil
} count [
    ["drawmapgraphics", 0],
    ["eventadded", 1],
    ["cursortargetchanged", 1],
    ["cursorobjectchanged", 1],
    ["playerinventorychanged", 1]
];

["hideObject", {
    (_this select 0) params ["_object", "_value"];
    _object hideObjectGlobal _value;
}] call CFUNC(addEventhandler);
["enableSimulation", {
    (_this select 0) params ["_object", "_value"];
    _object enableSimulationGlobal _value;
}] call CFUNC(addEventhandler);
["forceWalk", {
    (_this select 0) params ["_object", "_value"];
    _object forceWalk _value;
}] call CFUNC(addEventHandler);
["blockSprint", {
    (_this select 0) params ["_object", "_value"];
    _object allowSprint !_value;
}] call CFUNC(addEventHandler);
["fixFloating", {
    (_this select 0) params ["_object"];
    [_object] call CFUNC(fixFloating);
}] call CFUNC(addEventHandler);
["fixFloating", {
    (_this select 0) params ["_object"];
    [_object] call CFUNC(fixFloating);
}] call CFUNC(addEventHandler);
["fixPosition", {
    (_this select 0) params ["_object"];
    [_object] call CFUNC(fixPosition);
}] call CFUNC(addEventHandler);
["setCaptive", {
    (_this select 0) params ["_object", "_value"];
    _object setCaptive _value;
}] call CFUNC(addEventHandler);
["blockDamage", {
    (_this select 0) params ["_object", "_value"];
    _object allowDamage !_value;
}] call CFUNC(addEventHandler);
["deleteGroup", {
    (_this select 0) params ["_group"];

    if (isServer && !(isNull _group) && !(local _group)) exitWith {
        ["deleteGroup", groupOwner _group, _group] call CFUNC(targetEvent);
    };

    deleteGroup _group;
}] call CFUNC(addEventHandler);
["selectLeader", {
    (_this select 0) params ["_group", "_unit"];

    if (isServer && !(isNull _group) && !(local _group)) exitWith {
        ["selectLeader", groupOwner _group, [_group, _unit]] call CFUNC(targetEvent);
    };
    _group selectLeader _unit;
}] call CFUNC(addEventHandler);
["setVectorDirAndUp", {
    (_this select 0) params ["_obj", "_pos"];
    _obj setVectorDirAndUp _pos;
}] call CFUNC(addEventHandler);
["missionStarted", {
    GVAR(missionStartedTriggered) = true;
}] call CFUNC(addEventHandler);
["moveInCargo", {
    (_this select 0) params ["_vehicle", "_unit"];
    if (!(local _vehicle) && !(isNull _vehicle)) exitWith {
        ["moveInCargo", _vehicle, [_vehicle, _unit]] call CFUNC(targetEvent);
    };
    _unit moveInCargo _vehicle;
}] call CFUNC(addEventHandler);
["moveInDriver", {
    (_this select 0) params ["_vehicle", "_unit"];
    if (!(local _vehicle) && !(isNull _vehicle)) exitWith {
        ["moveInDriver", _vehicle, [_vehicle, _unit]] call CFUNC(targetEvent);
    };
    _unit moveInDriver _vehicle;
}] call CFUNC(addEventHandler);
["moveInTurret", {
    (_this select 0) params ["_vehicle", "_unit", "_turretPath"];
    if (!(local _vehicle) && !(isNull _vehicle)) exitWith {
        ["moveInTurret", _vehicle, [_vehicle, _unit, _turretPath]] call CFUNC(targetEvent);
    };
    _unit moveInTurret [_vehicle, _turretPath];
}] call CFUNC(addEventHandler);

["setMimic", {
    (_this select 0) params ["_unit", "_mimic"];
    if !(toLower(_mimic) in ["agresive", "angry", "cynic", "default", "hurt", "ironic", "normal", "sad", "smile", "surprised"]) then {
        _mimic = "neutral";
    };
    _unit setMimic _mimic;
}] call CFUNC(addEventhandler);

["setVehicleVarName", {
    (_this select 0) params ["_vehicle", "_name"];
    _vehicle setVehicleVarName _name;
}] call CFUNC(addEventhandler);

["missionStarted", {

    GVAR(entityCreatedSM) = call CFUNC(createStatemachine);

    DFUNC(entityCreated) = {
        params ["_obj"];
        if !(_obj getVariable [QGVAR(isProcessed), false] || _obj isKindOf "Animal" || _obj isKindOf "Logic") then {
            ["entityCreated", _obj] call CFUNC(localEvent);
            _obj setVariable [QGVAR(isProcessed), true];
        };
    };

    ["cursorObjectChanged", {
        (_this select 0) params ["_obj"];
        if (isNull _obj) exitWith {};
        _obj call FUNC(entityCreated);
    }] call CFUNC(addEventhandler);

    [GVAR(entityCreatedSM), "init", {
        GVAR(entitiesCached) = [];
        GVAR(entities) = [];
        "fillEntitiesCheck";
    }] call CFUNC(addStatemachineState);

    [GVAR(entityCreatedSM), "fillEntitiesCheck", {
        GVAR(entities) = (((entities "") - allUnits) + allUnits) - GVAR(entitiesCached);
        GVAR(lastFilledEntities) = diag_frameNo + 15;
        GVAR(entitiesCached) append GVAR(entities);
        GVAR(entitiesCached) = GVAR(entitiesCached) - [objNull];
        ["checkObject", "wait"] select (GVAR(entities) isEqualTo []);
    }] call CFUNC(addStatemachineState);

    [GVAR(entityCreatedSM), "checkObject", {
        private _obj = GVAR(entities) deleteAt 0;
        if !(isNull _obj) then {
            _obj call FUNC(entityCreated);
        };
        ["checkObject", "wait"] select (GVAR(entities) isEqualTo []);
    }] call CFUNC(addStatemachineState);

    [GVAR(entityCreatedSM), "wait", {
        ["wait", "fillEntitiesCheck"] select (diag_frameNo - (GVAR(lastFilledEntities)) >= 0); // only Fill every min 6 Frames the Cache for checking
    }] call CFUNC(addStatemachineState);

    [GVAR(entityCreatedSM)] call CFUNC(startStatemachine);

}] call CFUNC(addEventHandler);
