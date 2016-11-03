#include "macros.hpp"
/*
    Community Lib - CLib

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

private _requiredModules = ["clib"];
private _fnc_addRequiredModule = {
    params ["_moduleName"];
    private _i = _requiredModules pushBackUnique _moduleName;
    if (_i != -1) then {
        private _dependencies = parsingNamespace getVariable [format [QCGVAR(%1_dependency), _moduleName], []];
        {
            [_x] call _fnc_addRequiredModule;
            nil
        } count _dependencies;
    };
};

{
    [_x] call _fnc_addRequiredModule;
    nil
} count _this;

_requiredModules = _requiredModules apply { toLower _x; };

LOG("Loaded Modules: " + str _this)

{
    private _fullFunctionModuleName = (parsingNamespace getVariable (_x + "_data")) select 1;
    private _fullFunctionModName = (parsingNamespace getVariable (_x + "_data")) select 3;
    // Push the function name on the array if its in the requested module list.
    if (_fullFunctionModuleName in _requiredModules || _fullFunctionModName in _requiredModules) then {
        GVAR(requiredFunctions) pushBackUnique _x;
    };
    nil
} count (parsingNamespace getVariable QCGVAR(allFunctionNamesCached));

// EH for client registration. Starts transmission of function code.
// required Function that the Client needed
GVAR(RequiredFncClient) = GVAR(requiredFunctions) select { !((parsingNamespace getVariable (_x + "_data")) select 2) };

// Count requiredFunctions array and filter serverinit they dont need to sendet
GVAR(countRequiredFnc) = count GVAR(RequiredFncClient) - 1;

QGVAR(registerClient) addPublicVariableEventHandler {

    // Determine client id by provided object (usually the player object).
    private _clientID = owner (_this select 1);

    // send all Functions if mission Started was not triggered jet
    if (time < 100) exitWith {
        {
            [_x, _clientID, _forEachIndex] call FUNC(sendFunctions);
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

    GVAR(SendFunctionsUnitCache) = GVAR(SendFunctionsUnitCache) - [objNull];
};
// Call all required function on the server.
call FUNC(callModules);

// We need split up this to be sure that callModules is Done
call FUNC(sendFunctionsLoop);
