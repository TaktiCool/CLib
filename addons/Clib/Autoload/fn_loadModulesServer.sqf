#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: NetFusion

    Description:
    Server side modules loader (used when Clib is present on client too). Prepares the functions for transmission to clients. Should run before client register with server.

    Parameter(s):
    ARRAY - server only: the names of the requested modules

    Returns:
    None

    Example:
    ["Module1", "Module2"] call CFUNC(loadModulesServer);
*/


// Find all functions which are part of the requested modules and store them in an array.
GVAR(requiredFunctions) = [];
private _modules = [];

// Function for Cross Dependencys
private _fnc_addDependencyModule = {
    params ["_name"];
    private _i = _modules pushBackUnique _name;
    if (_i != -1) then {
        if (_name in (GVAR(Dependencies) select 0)) then {
            private _index = (GVAR(Dependencies) select 0) find _name;
            {
                _x call _fnc_addDependencyModule;
                nil
            } count ((GVAR(Dependencies) select 1) select _index);
        };
    };
};

{
    _x call _fnc_addDependencyModule;
    nil
} count _this;

LOG("Loaded Modules: " + str _modules)
private _prefixLength = (count QPREFIX) + 1;
{
    // Extract the module name out of the full function name.
    // 1: Remove "Clib_" prefix
    private _functionModuleName = _x select [_prefixLength, count _x - 6];
    // 2: All characters until the next "_" are the module name.
    _functionModuleName = _functionModuleName select [0, _functionModuleName find "_"];

    // Push the function name on the array if its in the requested module list.
    if (_functionModuleName in _modules) then {
        GVAR(requiredFunctions) pushBack _x;
    };
    nil
} count GVAR(functionCache);

// EH for client registration. Starts transmission of function code.
if (isServer) then {

    // required Function that the Client needed
    GVAR(RequiredFncClient) = GVAR(requiredFunctions) select {(toLower(_x) find "_fnc_serverinit" < 0)};

    // Count requiredFunctions array and filter serverinit they dont need to sendet
    GVAR(countRequiredFnc) = count GVAR(RequiredFncClient) - 1;

    QGVAR(registerClient) addPublicVariableEventHandler {

        // Determine client id by provided object (usually the player object).
        private _clientID = owner (_this select 1);

        // send all Functions if mission Started was not triggered jet
        if (isNil QGVAR(missionStartedTriggered)) exitWith {
            {
                [_x, _clientID, _forEachIndex] call CFUNC(sendFunctions);
            } forEach GVAR(RequiredFncClient);
        };

        if (isNil QGVAR(SendFunctionsUnitCache)) then {
            GVAR(SendFunctionsUnitCache) = [[_clientID, +GVAR(RequiredFncClient), 0]];
        } else {
            GVAR(SendFunctionsUnitCache) pushBack [_clientID, +GVAR(RequiredFncClient), 0];
        };

    };
};

// Call all required function on the server.
call CFUNC(callModules);

// We need split up this to be sure that callModules is Done
if (isServer) then {
    call CFUNC(sendFunctionsLoop);
};
