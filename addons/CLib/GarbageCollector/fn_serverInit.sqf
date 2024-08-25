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

DFUNC(pushbackInQueue) = [{
    params ["_object"];
    if (_object getVariable ["BIS_fnc_moduleRespawnVehicle_data", []] isNotEqualTo []) exitWith {
        _object setVariable [QCGVAR(noClean), true, true]; // Dont Pushback Vehciles that are handled by BIS Respawn Module
    };
    if !(_object getVariable [QCGVAR(noClean), false]) then {
        if !(isNull attachedTo _object) exitWith {}; // exit if the Object is attached to a object. we then ignore it because it could be used by a script
        if (!(_object getVariable [QGVAR(queued), false])) then {
            _object setVariable [QGVAR(queued), true];
            [{
                _this call FUNC(removeMissionObject);
            }, GVAR(waitTime), _object] call CFUNC(wait);
        };
    };
}] call CFUNC(compileFinal);

DFUNC(removeMissionObject) = [{
    params [["_object", objNull]];
    if (isNull _object) exitWith {};
    if (_object getVariable ["BIS_fnc_moduleRespawnVehicle_data", []] isNotEqualTo []) exitWith {
        _object getVariable [QCGVAR(noClean), true, true]; // Dont Pushback Vehciles that are handled by BIS Respawn Module
    };
    if (_object getVariable [QCGVAR(noClean), false]) exitWith {};
    // Disable collision with the surface.
    _object enableSimulationGlobal false;

    // Calculate the height of the object to determine whether its below surface.
    private _boundingBox = boundingBox _object;
    private _height = ((_boundingBox select 1) select 2) - ((_boundingBox select 0) select 2);

    // Use an WaitUntil to move the object slowly below the surface.
    [{
        params ["_object"];
        deleteVehicle _object;
    }, {
        params ["_object", "_height", "_position"];

        // Get the current position and subtract some value from the z axis.
        _position set [2, (_position select 2) - 0.02];

        // Apply the position change.
        _object setPosATL _position;

        (_position select 2) < (0 - _height)
    }, [_object, _height, getPosATL _object]] call CFUNC(waitUntil);
}] call CFUNC(compileFinal);

GVAR(statemachine) = call CFUNC(createStatemachine);

[GVAR(statemachine), "init", {
    private _configPath = (missionConfigFile >> QPREFIX >> "GarbageCollector");
    // time to wait until the objet gets deleted
    GVAR(waitTime) = if (isNumber (_configPath >> "GarbageCollectorTime")) then {
        getNumber (_configPath >> "GarbageCollectorTime")
    } else {
        120
    };
    GVAR(loopTime) = if (isNumber (_configPath >> "GarbageCollectorLoopTime")) then {
        getNumber (_configPath >> "GarbageCollectorLoopTime")
    } else {
        GVAR(waitTime) / 5;
    };
    "fillGrenades"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "fillGrenades", {
    GVAR(lastFilledTime) = time + GVAR(loopTime);
    // Cycle through all units to detect near shells and enqueue them for removal.
    {
        // Cycle through all near shells.
        {
            // If the shell is not queued yet push it on the storage.
            _x call FUNC(pushbackInQueue);
        } forEach ((getPos _x) nearObjects ["GrenadeHand", 100]);
    } forEach allUnits;
    "fillWeaponHolder"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "fillWeaponHolder", {
    {
        _x call FUNC(pushbackInQueue);
    } forEach (allMissionObjects "WeaponHolder");
    "fillGroundWeaponHolder"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "fillGroundWeaponHolder", {
    {
        _x call FUNC(pushbackInQueue);
    } forEach (allMissionObjects "GroundWeaponHolder");
    "fillWeaponHolderSimulated"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "fillWeaponHolderSimulated", {
    {
        _x call FUNC(pushbackInQueue);
    } forEach (allMissionObjects "WeaponHolderSimulated");
    "fillDeadUnits"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "fillDeadUnits", {
    {
        _x call FUNC(pushbackInQueue);
    } forEach allDead;
    "checkGroups"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "checkGroups", {
    // Remove empty groups.
    {
        if !(_x getVariable [QCGVAR(noClean), false]) then {
            if ((units _x) isEqualTo []) then {
                ["deleteGroup", groupOwner _x, _x] call CFUNC(targetEvent);
            };
        };
    } forEach allGroups;
    "wait"
}] call CFUNC(addStatemachineState);

[GVAR(statemachine), "wait", {
    ["wait", "fillGrenades"] select (GVAR(lastFilledTime) < time);
}] call CFUNC(addStatemachineState);

[GVAR(statemachine)] call CFUNC(startStatemachine);
