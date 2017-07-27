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
uiNamespace setVariable ["CLib_Player", player];
parsingNamespace setVariable ["CLib_Player", player];
["playerChanged", {
    (_this select 0) params ["_newPlayer"];

    CLib_Player = _newPlayer;
    uiNamespace setVariable ["CLib_Player", _newPlayer];
    parsingNamespace setVariable ["CLib_Player", _newPlayer];
}] call CFUNC(addEventHandler);

// To ensure that the ingame display is available and prevent unnecessary draw3D calls during briefings we trigger an event if the mission starts.
[{
    // If ingame display is available trigger the event.
    ["missionStarted"] call CFUNC(localEvent);

    ["playerJoined", CLib_Player] call CFUNC(globalEvent);
}, {!(isNull (findDisplay 46))}] call CFUNC(waitUntil);

// EventHandler to ensure that missionStarted EH get triggered if the missionStarted event already fired
["eventAdded", {
    params ["_arguments", "_data"];
    _arguments params ["_event", "_function", "_args"];
    if ((!(isNil QGVAR(missionStartedTriggered)) || !(isNull (findDisplay 46))) && {_event isEqualTo "missionStarted"}) then {
        LOG("Mission Started Event get Added After Mission Started");
        if (_function isEqualType "") then {
            _function = parsingNamespace getVariable [_function, {}];
        };
        [nil, _args] call _function;
    };
}] call CFUNC(addEventHandler);


private _codeStr = "private ['_oldValue', '_currentValue'];";
// Build a dynamic event system to use it in modules.
{
    _x params ["_name", "_code"];

    // Build a name for the variable where we store the data. Fill it with the initial value.
    GVAR(EventNamespace) setVariable [_name, call _code];
    _codeStr = _codeStr + format ["_oldValue = %4 getVariable '%2'; _currentValue = call %1; if (!(_oldValue isEqualTo _currentValue)) then { ['%2Changed', [_currentValue, _oldValue]] call %3; _oldValue = %4 setVariable ['%2', _currentValue]; };", _code, _name, QCFUNC(localEvent), QGVAR(EventNamespace)];
    nil
} count [
    ["player", {missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player]}],
    ["currentThrowable", {currentThrowable CLib_Player}],
    ["currentWeapon", {currentWeapon CLib_Player}],
    ["vehicle", {vehicle CLib_Player}],
    ["assignedVehicleRole", {assignedVehicleRole CLib_Player}], // This has to be after "vehicle"
    ["side", {side CLib_Player}],
    ["group", {group CLib_Player}],
    ["leader", {leader CLib_Player}],
    ["getConnectedUAV", {getConnectedUAV CLib_Player}],
    ["currentVisionMode", {currentVisionMode CLib_Player}],
    ["playerInventory", {CLib_Player call CFUNC(getAllGear)}],
    ["visibleMap", {visibleMap}],
    ["playerSide", {playerSide}],
    ["cursorTarget", {cursorTarget}],
    ["cursorObject", {cursorObject}],
    ["groupUnits", {units CLib_Player}]
];

[compile _codeStr, 0] call CFUNC(addPerFrameHandler);

// Import the vanilla events in the event system.
{
    // The event has the same name and data as the vanilla version.
    private _code = compile format ["[""%1"", _this] call %2", _x, QCFUNC(localEvent)];

    // Bind it to the current player and store the index to delete it.
    private _index = CLib_Player addEventHandler [_x, _code];
    DUMP("Eventhandler Added: " + _x);
    // If the player changes remove the old EH and bind a new one.
    ["playerChanged", {
        params ["_data", "_params"];
        _data params ["_currentPlayer", "_oldPlayer"];
        _params params ["_name", "_code", "_index"];

        // Remove the old one.
        _oldPlayer removeEventHandler [_name, _index];

        // Some EH get rebound automatically on death. To prevent double EH we remove EH from new player first.
        _currentPlayer removeEventHandler [_name, _index];
        DUMP("Eventhandler Added To New Player: " + _name);
        // Bind a new one and update the index in the params.
        _params set [2, _currentPlayer addEventHandler [_name, _code]];
    }, [_x, _code, _index]] call CFUNC(addEventHandler);
    nil
} count [
    "InventoryOpened",
    "Killed",
    "Respawn",
    "AnimStateChanged",
    "HandleDamage"
];

// Fix an Arma bug
["vehicleChanged", {
    (_this select 0) params ["_newVehicle"];

    if (_newVehicle == CLib_Player) then {
        unassignVehicle CLib_Player;
    };
}] call CFUNC(addEventHandler);
