#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init the Cleanup Script on the Server

    Parameter(s):
    None

    Returns:
    None
*/

if (getNumber (missionConfigFile >> QPREFIX >> "GarbageCollector" >> "EnableGarbageCollector") isEqualTo 0) exitWith {};

DFUNC(pushbackInQueue) = {
    params ["_object"];
    if !(isNull attachedTo _object) exitWith { // exit if the Object is attached to a object. we then ignore it because it could be used by a script
        _object setVariable [QCGVAR(noClean), true, true];
    };
    if (!(_object getVariable [QCGVAR(noClean), false])) then {
        if (!(_object getVariable [QGVAR(queued), false])) then {
            _object setVariable [QGVAR(queued), true];
            GVAR(objectStorage) pushBack [_object, time + GVAR(waitTime)];
        };
    };
};

GVAR(statemachine) = call CFUNC(createStatemachine);

[GVAR(statemachine), "init", {
    private _configPath = (missionConfigFile >> QPREFIX >> "GarbageCollector" >> "GarbageCollectorTime");
    GVAR(waitTime) = if (isNumber _configPath) then {
        getNumber _configPath
    } else {
        120
    };

    GVAR(objectStorage) = [];
    GVAR(lastFilledTime) = time;
    "fillGrenades"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "fillGrenades", {
    // Cycle through all units to detect near shells and enqueue them for removal.
    {
        // Cycle through all near shells.
        {
            // If the shell is not queued yet push it on the storage.
            _x call DFUNC(pushbackInQueue);
            nil
        } count (getPos _x nearObjects ["GrenadeHand", 100]);
        nil
    } count allUnits;
    "fillObjects"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "fillObjects", {
    {
        _x call DFUNC(pushbackInQueue);
        nil
    } count (allMissionObjects "WeaponHolder") + (allMissionObjects "GroundWeaponHolder") + (allMissionObjects "WeaponHolderSimulated") + allDead;
    "checkObject"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "checkObject", {
    (GVAR(objectStorage) select 0) params ["_object", "_enqueueTime"];

    // If the time has not passed exit. This assumes all following object are pushed after the current one.
    if (isNull _object) exitWith {
        GVAR(objectStorage) deleteAt 0;
        ["checkObject", "checkGroups"] select (GVAR(objectStorage) isEqualTo []);
    };
    if (_enqueueTime > time) exitWith {
        ["checkObject", "checkGroups"] select (GVAR(objectStorage) isEqualTo []);
    };
    if !(_object getVariable [QCGVAR(noClean), false]) then {

        // Remove the object from the storage.
        GVAR(objectStorage) deleteAt 0;
        // Disable collision with the surface.
        _object enableSimulationGlobal false;

        // Calculate the height of the object to determine whether its below surface.
        private _boundingBox = boundingBox _object;
        private _height = ((_boundingBox select 1) select 2) - ((_boundingBox select 0) select 2);

        // Use an PFH to move the object slowly below the surface.
        // TODO make this optional cause it should not be visible in general.
        [{
            params ["_object"];
            deleteVehicle _object;
        }, {
            params ["_object", "_height", "_position"];

            // Get the current position and subtract some value from the z axis.
            _position set [2, (_position select 2) - 0.02];

            // Apply the position change.
            _object setPos _position;

            (_position select 2) < (0 - _height)
        }, [_object, _height, getPos _object]] call CFUNC(waitUntil);
    } else {
        GVAR(objectStorage) deleteAt (GVAR(objectStorage) find _x);
    };
    ["checkObject", "checkGroups"] select (GVAR(objectStorage) isEqualTo []);
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "checkGroups", {
    // Remove empty groups.
    {
        if !(_x getVariable [QCGVAR(noClean), false]) then {
            if ((units _x) isEqualTo []) then {
                ["deleteGroup", groupOwner _x, _x] call CFUNC(targetEvent);
            };
        };
        nil
    } count allGroups;
    "wait"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "wait", {
    ["wait", "fillGrenades"] select (time - (GVAR(lastFilledTime)) >= 0); // only Fill every min 6 Frames the Cache for checking
}] call CFUNC(addStatemachineState);

[GVAR(statemachine)] call CFUNC(startStatemachine);
