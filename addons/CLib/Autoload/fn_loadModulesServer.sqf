#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: NetFusion

    Description:
    Server side modules loader (used when CLib is present on client too). Prepares the functions for transmission to clients. Should run before client register with server.

    Parameter(s):
    ARRAY - server only: the names of the requested modules

    Returns:
    None

    Example:
    ["Module1", "Module2"] call CFUNC(loadModulesServer);
*/
// Find all functions which are part of the requested modules and store them in an array.
GVAR(requiredFunctions) = [];

private _requiredModules = [];
private _fnc_addRequiredModule = {
    params ["_moduleName"];
    _requiredModules pushBackUnique _moduleName;
    private _dependencies = parsingNamespace getVariable [format [QGVAR(%1_dependency), _moduleName], []];
    {
        [_x] call _fnc_addRequiredModule;
    } count _dependencies;
    nil
};

{
    [_x] call _fnc_addRequiredModule;
    nil
} count _this;

LOG("Loaded Modules: " + str _this)

{
    private _fullFunctionModuleName = (parsingNamespace getVariable (_x + "_data")) select 1;
    // Push the function name on the array if its in the requested module list.
    if (_fullFunctionModuleName in _requiredModules) then {
        GVAR(requiredFunctions) pushBack _x;
    };
    nil
} count (parsingNamespace getVariable QCGVAR(allFunctionNamesCached));

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

    QGVAR(unregisterClient) addPublicVariableEventHandler {
        private _clientID = owner (_this select 1);
        {
            if ((_x select 0) == _clientID) then {
                GVAR(SendFunctionsUnitCache) set [_forEachIndex, objNull];
            };
        } forEach GVAR(SendFunctionsUnitCache);

        GVAR(SendFunctionsUnitCache) = GVAR(SendFunctionsUnitCache) - [];
    };
};

// Call all required function on the server.
call CFUNC(callModules);

// We need split up this to be sure that callModules is Done
if (isServer) then {
    call CFUNC(sendFunctionsLoop);
};
