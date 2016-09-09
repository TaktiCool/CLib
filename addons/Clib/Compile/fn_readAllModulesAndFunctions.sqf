#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: joko // Jonas

    Description:
    this function read all Modules and functions and build the base of Clib and other modules that build on it

    Parameter(s):
    None

    Returns:
    None
*/

#ifndef isDev
if !(isNil {parsingNamespace getVariable QGVAR(allFunctionNamesCached)}) exitWith {
    {
        _x params ["_folderPath", "_api", "_onlyServer", "_priority"];
        [_folderPath, _x, _modName, _priority] call CFUNC(compile);
        nil
    } count parsingNamespace getVariable QGVAR(allFunctionNamesCached);
};
#endif

GVAR(allFunctionNamesCached) = [];

private _fnc_getLastPartent = {
    private _parents = [_this, true] call BIS_fnc_returnParents;
    reverse _parents;
    _parents select 0;
};

private _fnc_callNextState = {
    params ["_configPath"];

    switch (_configPath call _fnc_getLastPartent) do {
        case ("ClibBaseFunction"): {
            _configPath call _fnc_readFunction;
        };
        case ("ClibBaseModule"): {
            _configPath call _fnc_readModule;
        };
        default {
            LOG("Error in Module Parsing: " + configName _x + " inherits not from a required base class!");
        };
    }
};

private _fnc_readModule = {
    params ["_configPath"];

    DUMP("Module Found: " + _moduleName)
    {
        private _subModuleName = configName _x;

        private _modulePath = format ["%1\%2", _modulePath, _subModuleName];
        DUMP("SubModule Found: " + _subModuleName + " in Path: " + _modulePath)
        _x call _fnc_callNextState;
        nil
    } count configProperties [_configPath, "isClass _x", true];
};

private _fnc_readFunction = {
    params ["_configPath"];

    private _name = configName _configPath;

    private _api = getNumber (_configPath >> "api") isEqualTo 1;
    private _onlyServer = getNumber (_configPath >> "onlyServer") isEqualTo 1;

    if ((toLower(_name) find "_fnc_serverinit" < 0)) then {
        _onlyServer = true;
    };

    private _priority = getNumber (_configPath >> "priority");

    private _functionName = format [(["%1_%2_fnc_%3","%1_fnc_%3"] select _api), _modName, _moduleName, _name];

    private _folderPath = format ["%1\%2.sqf", _modulePath];
    [_folderPath, _functionName, _modName] call CFUNC(compile);

    parsingNamespace setVariable [_functionName + "_data", [_folderPath, _api, _onlyServer, _priority, _modName, _priority]];
    GVAR(allFunctionNamesCached) pushBackUnique _functionName;
    DUMP("Function Found: " + _functionName + " in Path: " + _folderPath)
};

DUMP("start Clib Module Search")
diag_log "-----------------------------------------------------------";
{

    private _modName = configName _x;
    private _modPath = getText (_x >> "path");
    DUMP("Mod Found: " + _modName + " in Path: " + _modPath)
    {
        private _moduleName = configName _x;
        private _modulePrefix = format ["%1_%2", _modName, _moduleName];
        private _modulePath = format ["%1\%2", _modPath, _moduleName];
        _x call _fnc_readModule;
        nil
    } count configProperties [_x, "isClass _x", true];
    nil
} count configProperties [configFile >> "CfgClibModules", "isClass _x", true];
parsingNamespace setVariable [QGVAR(allFunctionNamesCached), GVAR(allFunctionNamesCached)];
DUMP("End Clib Module Search")
diag_log "-----------------------------------------------------------";
