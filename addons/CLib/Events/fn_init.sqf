#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init for events

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
    ["playerinventorychanged", 1],
    [QEGVAR(ExtensionFramework,extensionRequest), 0],
    [QEGVAR(ExtensionFramework,extensionResult), 0]
];

// Events for serveronly commands
["hideObject", {
    (_this select 0) params ["_object", "_value"];
    if (!isServer) exitWith {
        LOG("HideObject has to be a server event");
    };
    _object hideObjectGlobal _value;
}] call CFUNC(addEventhandler);
["enableSimulation", {
    (_this select 0) params ["_object", "_value"];
    if (!isServer) exitWith {
        LOG("EnableSimulation has to be a server event");
    };
    _object enableSimulationGlobal _value;
}] call CFUNC(addEventhandler);

// Events for commands with local args
["fixFloating", {
    (_this select 0) params ["_object"];
    if (!local _object) exitWith {
        LOG("FixFloating has to be a target event");
    };
    _object call CFUNC(fixFloating);
}] call CFUNC(addEventHandler);
["setVectorUp", {
    (_this select 0) params ["_object", "_vector"];
    if (!local _object) exitWith {
        LOG("SetVectorUp has to be a target event");
    };
    _object setVectorUp _vector;
}] call CFUNC(addEventHandler);
["allowDamage", {
    (_this select 0) params ["_object", "_allow"];
    if (!local _object) exitWith {
        LOG("AllowDamage has to be a target event");
    };
    _object allowDamage _allow;
}] call CFUNC(addEventHandler);
["setFuel", {
    (_this select 0) params ["_vehicle", "_value"];
    if (!local _vehicle) exitWith {
        LOG("SetFuel has to be a target event");
    };
    _vehicle setFuel _value;
}] call CFUNC(addEventHandler);
["removeMagazineTurret", {
    (_this select 0) params ["_vehicle", "_args"];
    if (!local _vehicle) exitWith {
        LOG("RemoveMagazineTurret has to be a target event");
    };
    _vehicle removeMagazineTurret _args;
}] call CFUNC(addEventHandler);
["addMagazineTurret", {
    (_this select 0) params ["_vehicle", "_args"];
    if (!local _vehicle) exitWith {
        LOG("AddMagazineTurret has to be a target event");
    };
    _vehicle addMagazineTurret _args;
}] call CFUNC(addEventHandler);

// Events for commands with owner ids
["deleteGroup", {
    (_this select 0) params ["_group"];
    if (isServer && (!isNull _group) && (!local _group)) exitWith {
        ["deleteGroup", groupOwner _group, _group] call CFUNC(targetEvent);
    };
    if (!local _group) exitWith {
        LOG("DeleteGroup has to be a server event");
    };
    deleteGroup _group;
}] call CFUNC(addEventHandler);
["selectLeader", {
    (_this select 0) params ["_group", "_unit"];
    if (isServer && (!isNull _group) && (!local _group)) exitWith {
        ["selectLeader", groupOwner _group, [_group, _unit]] call CFUNC(targetEvent);
    };
    if (!local _group) exitWith {
        LOG("SelectLeader has to be a server event");
    };
    _group selectLeader _unit;
}] call CFUNC(addEventHandler);

// Events for commands with local effect
["setMimic", {
    (_this select 0) params ["_unit", "_mimic"];
    if !(toLower _mimic in ["agresive", "angry", "cynic", "default", "hurt", "ironic", "normal", "sad", "smile", "surprised"]) then {
        _mimic = "neutral";
    };
    _unit setMimic _mimic;
}] call CFUNC(addEventhandler);
["setVehicleVarName", {
    (_this select 0) params ["_vehicle", "_name"];
    _vehicle setVehicleVarName _name;
}] call CFUNC(addEventhandler);

["missionStarted", {
    GVAR(missionStartedTriggered) = true;

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
        GVAR(entities) = (entities [[], [], true, false]);
        GVAR(entities) append allMissionObjects "All";
        GVAR(entities) = GVAR(entities) - GVAR(entitiesCached);
        GVAR(entities) = GVAR(entities) arrayIntersect GVAR(entities);
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
