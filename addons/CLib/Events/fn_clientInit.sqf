#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    This function is the entry point for the core module. It is called by autoloader for all clients. It adds OEF EH to trigger some common events.

    Parameter(s):
    None

    Returns:
    None
*/

// This is needed to provide a player object for zeus controlled units. Important to ensure that player is not null here (which is done in autoload).
CLib_Player = player;
GVAR(oldGear) = CLib_Player call CFUNC(getAllGear);
GVAR(oldVisibleMap) = false;
GVAR(oldPLayerSide) = playerSide;
GVAR(oldCursorObject) = objNull;
GVAR(oldCursorTarget) = objNull;
GVAR(groupUnits) = [];
[{
    // There is no command to get the current player but BI has an variable in mission namespace we can use.
    private _data = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];
    // If the player changed we trigger an event and update the global variable.
    if (CLib_Player != _data && !(isNull _data)) then {
        ["playerChanged", [_data, CLib_Player]] call CFUNC(localEvent);
        CLib_Player = _data;
    };

    _data = CLib_Player call CFUNC(getAllGear);
    if !(_data isEqualTo GVAR(oldGear)) then {
        "playerInventoryChanged" call CFUNC(localEvent);
        GVAR(oldGear) = _data;
    };

    _data = visibleMap;
    if (!(_data isEqualTo GVAR(OldVisibleMap))) then {
        ["visibleMapChanged", [_data, GVAR(OldVisibleMap)]] call CFUNC(localEvent);
        GVAR(OldVisibleMap) = _data;
    };

    _data = playerSide;
    if (!(_data isEqualTo GVAR(OldPLayerSide))) then {
        ["playerSideChanged", [_data, GVAR(OldPLayerSide)]] call CFUNC(localEvent);
        GVAR(OldPLayerSide) = _data;
    };

    _data = cursorTarget;
    if (!(_data isEqualTo GVAR(oldCursorTarget))) then {
        ["cursorTargetChanged", _data] call CFUNC(localEvent);
        GVAR(oldCursorTarget) = _data;
    };

    _data = cursorObject;
    if (!(_data isEqualTo GVAR(oldCursorObject))) then {
        ["cursorObjectChanged", _data] call CFUNC(localEvent);
        GVAR(oldCursorObject) = _data;
    };

    _data = units CLib_Player;
    if !(GVAR(groupUnits) isEqualTo _data) then {
        ["groupUnitsChanged", _data] call CFUNC(localEvent);
        GVAR(groupUnits) = _data;
    };
}] call CFUNC(addPerFrameHandler);


// To ensure that the ingame display is available and prevent unnecessary draw3D calls during briefings we trigger an event if the mission starts.
[{
    // If ingame display is available trigger the event and remove the OEF EH to ensure that the event is only triggered once.
    "missionStarted" call CFUNC(localEvent);

    ["playerJoined", CLib_Player] call CFUNC(globalEvent);
}, {!(isNull (findDisplay 46))}] call CFUNC(waitUntil);

// EventHandler to ensure that missionStarted EH get triggered if the missionStarted event already fired
["eventAdded", {
    params ["_arguments", "_data"];
    _arguments params ["_event", "_function", "_args"];
    if ((!(isNil QGVAR(missionStartedTriggered)) || !(isNull (findDisplay 46)))&& {_event isEqualTo "missionStarted"}) then {
        LOG("Mission Started Event get Added After Mission Started")
        if (_function isEqualType "") then {
            _function = parsingNamespace getVariable [_function, {}];
        };
        [nil, _args] call _function;
    };
}] call CFUNC(addEventHandler);

// Build a dynamic event system to use it in modules.
{
    private _code = compile format ["%1 CLib_Player", _x];

    // Build a name for the variable where we store the data. Fill it with the initial value.
    GVAR(EventNamespace) setVariable [_x, call _code];

    // Use an OEF EH to detect if the value changes.
    [{
        params ["_params"];
        _params params ["_name", "_code"];

        // Read the value we detected earlier.
        private _oldValue = GVAR(EventNamespace) getVariable _name;

        // If the value changed trigger the event and update the value in out variable.
        _currentValue = call _code;
        if (!(_oldValue isEqualTo _currentValue)) then {
            [_name + "Changed", [_currentValue, _oldValue]] call CFUNC(localEvent);
            GVAR(EventNamespace) setVariable [_name, _currentValue];
        };
    }, 0, [_x, _code]] call CFUNC(addPerFrameHandler);

    true
} count [
    "currentThrowable",
    "currentWeapon",
    "vehicle",
    "assignedVehicleRole", // This has to be after "vehicle"
    "side",
    "group",
    "leader",
    "getConnectedUAV",
    "currentVisionMode"
];

// Import the vanilla events in the event system and provide a permanent zeus compatible player.
{
    // The event has the same name and data as the vanilla version.
    private _code = compile format ["[""%1"", _this] call %2", _x, QCFUNC(localEvent)];

    // Bind it to the current player and store the index to delete it.
    private _index = CLib_Player addEventHandler [_x, _code];
    DUMP("Eventhandler Added: " +
    _x)
    // If the player changes remove the old EH and bind a new one.
    ["playerChanged", {
        params ["_data", "_params"];
        _data params ["_currentPlayer", "_oldPlayer"];
        _params params ["_name", "_code", "_index"];

        // Remove the old one.
        _oldPlayer removeEventHandler [_name, _index];

        // Some EH get rebound automatically on death. To prevent double EH we remove EH from new player first.
        _currentPlayer removeEventHandler [_name, _index];
        DUMP("Eventhandler Added To New Player: " + _name)
        // Bind a new one and update the index in the params.
        _params set [2, _currentPlayer addEventHandler [_name, _code]];
    }, [_x, _code, _index]] call CFUNC(addEventHandler);
    nil
} count [
    "InventoryOpened",
    "Killed",
    "Respawn",
    "AnimStateChanged"
];

// Fix an Arma bug
["vehicleChanged", {
    (_this select 0) params ["_newVehicle"];

    if (_newVehicle == CLib_Player) then {
        unAssignVehicle CLib_Player;
    };
}] call CFUNC(addEventHandler);
