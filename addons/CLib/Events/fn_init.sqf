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
["assignCurator", {
    (_this select 0) params ["_player", "_curatorObject"];
    if (!isServer) exitWith {
        LOG("AssignCurator has to be a server event");
    };
    _player assignCurator _curatorObject;
}] call CFUNC(addEventhandler);
["unassignCurator", {
    (_this select 0) params ["_curatorObject"];
    if (!isServer) exitWith {
        LOG("UnassignCurator has to be a server event");
    };
    unassignCurator _curatorObject;
}] call CFUNC(addEventhandler);
["addCuratorEditableObjects", {
    (_this select 0) params ["_curatorObject", "_args"];
    if (!isServer) exitWith {
        LOG("AddCuratorEditableObjects has to be a server event");
    };
    _curatorObject addCuratorEditableObjects _args;
}] call CFUNC(addEventhandler);

// Events for commands with local args
["fixFloating", {
    (_this select 0) params ["_object"];
    if (!local _object) exitWith {
        LOG("FixFloating event has wrong locality");
        ["fixFloating", _object, _this select 0] call CFUNC(targetEvent);
    };
    _object call CFUNC(fixFloating);
}] call CFUNC(addEventHandler);
["playMove", {
    (_this select 0) params ["_unit", "_move"];
    if (!local _unit) exitWith {
        LOG("PlayMove event has wrong locality");
        ["playMove", _unit, _this select 0] call CFUNC(targetEvent);
    };
    _unit playMove _move;
}] call CFUNC(addEventHandler);
["playMoveNow", {
    (_this select 0) params ["_unit", "_move"];
    if (!local _unit) exitWith {
        LOG("PlayMoveNow event has wrong locality");
        ["playMoveNow", _unit, _this select 0] call CFUNC(targetEvent);
    };
    _unit playMoveNow _move;
}] call CFUNC(addEventHandler);
["setVectorUp", {
    (_this select 0) params ["_object", "_vector"];
    if (!local _object) exitWith {
        LOG("SetVectorUp event has wrong locality");
        ["setVectorUp", _object, _this select 0] call CFUNC(targetEvent);
    };
    _object setVectorUp _vector;
}] call CFUNC(addEventHandler);
["allowDamage", {
    (_this select 0) params ["_object", "_allow"];
    if (!local _object) exitWith {
        LOG("AllowDamage event has wrong locality");
        ["allowDamage", _object, _this select 0] call CFUNC(targetEvent);
    };
    _object allowDamage _allow;
}] call CFUNC(addEventHandler);
["setFuel", {
    (_this select 0) params ["_vehicle", "_value"];
    if (!local _vehicle) exitWith {
        LOG("SetFuel event has wrong locality");
        ["setFuel", _vehicle, _this select 0] call CFUNC(targetEvent);
    };
    _vehicle setFuel _value;
}] call CFUNC(addEventHandler);
["removeMagazineTurret", {
    (_this select 0) params ["_vehicle", "_args"];
    if (!local _vehicle) exitWith {
        LOG("RemoveMagazineTurret event has wrong locality");
        ["removeMagazineTurret", _vehicle, _this select 0] call CFUNC(targetEvent);
    };
    _vehicle removeMagazineTurret _args;
}] call CFUNC(addEventHandler);
["addMagazineTurret", {
    (_this select 0) params ["_vehicle", "_args"];
    if (!local _vehicle) exitWith {
        LOG("AddMagazineTurret event has wrong locality");
        ["addMagazineTurret", _vehicle, _this select 0] call CFUNC(targetEvent);
    };
    _vehicle addMagazineTurret _args;
}] call CFUNC(addEventHandler);

// Events for commands with owner ids
["deleteGroup", {
    (_this select 0) params ["_group"];
    if (isNull _group) exitWith {};
    if (!local _group) exitWith {
        if (isServer) exitWith {
            ["deleteGroup", groupOwner _group, _group] call CFUNC(targetEvent);
        };
        LOG("DeleteGroup event has wrong locality");
        ["deleteGroup", _this select 0] call CFUNC(serverEvent);
    };
    deleteGroup _group;
}] call CFUNC(addEventHandler);
["selectLeader", {
    (_this select 0) params ["_group", "_unit"];
    if (isNull _group) exitWith {};
    if (!local _group) exitWith {
        if (isServer) exitWith {
            ["selectLeader", groupOwner _group, [_group, _unit]] call CFUNC(targetEvent);
        };
        LOG("SelectLeader event has wrong locality");
        ["selectLeader", _this select 0] call CFUNC(serverEvent);
    };
    _group selectLeader _unit;
}] call CFUNC(addEventHandler);

// Events for commands with local effect
["switchMove", {
    (_this select 0) params ["_unit", "_move"];
    _unit switchMove _move;
}] call CFUNC(addEventHandler);
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
        if !(_obj getVariable [QGVAR(isProcessed), false] || _obj isKindOf "Animal" || _obj isKindOf "Logic" || (typeOf _obj) isEqualTo "") then {
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
        GVAR(entities) = (entities [[], [], true, false]);
        GVAR(entities) append allMissionObjects "All";
        "clearOutEntits"
    }] call CFUNC(addStatemachineState);

    [GVAR(entityCreatedSM), "refillEntitiesData", {
        GVAR(entities) = (entities [[], [], true, false]);
        "clearOutEntits"
    }] call CFUNC(addStatemachineState);

    [GVAR(entityCreatedSM), "clearOutEntits", {
        GVAR(entities) = GVAR(entities) - GVAR(entitiesCached);
        GVAR(entities) = GVAR(entities) arrayIntersect GVAR(entities);
        "applyNewEntitieVariables"
    }] call CFUNC(addStatemachineState);

    [GVAR(entityCreatedSM), "applyNewEntitieVariables", {
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
        ["wait", "refillEntitiesData"] select (diag_frameNo - (GVAR(lastFilledEntities)) >= 0); // only Fill every min 15 Frames the Cache for checking
    }] call CFUNC(addStatemachineState);

    [GVAR(entityCreatedSM)] call CFUNC(startStatemachine);

}] call CFUNC(addEventHandler);
