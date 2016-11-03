#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    this function read all Modules and functions and build the base of CLib and other modules that build on it

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(allFunctionNamesCached) = [];

private _fnc_checkNext = {
    params ["_modPath", "_modName", "_moduleName", "_modulePath", "_config"];
    private _children = configProperties [_config, "isClass _x", true];
    if (_children isEqualTo []) then {
        [_modPath, _modName, _moduleName, _modulePath, _config] call _fnc_readFunction;
    } else {
        [_modPath, _modName, _moduleName, _modulePath,_config, _children] call _fnc_readSubModule
    };
};

private _fnc_readSubModule = {
    params ["_modPath", "_modName", "_moduleName", "_modulePath", "_config", "_children"];
    DUMP("SubModule Found: " + configName _x)
    private _subModuleName = configName _x;
    {
        private _modulePath = +_modulePath;
        _modulePath pushBack _subModuleName;
        [_modPath, _modName, _moduleName, _modulePath, _x] call _fnc_checkNext;
        nil
    } count _children;
};

private _fnc_readFunction = {
    params ["_modPath", "_modName", "_moduleName", "_modulePath", "_config"];

    _modulePath = _modulePath joinString "\";

    private _name = configName _config;
    private _api = (getNumber (_config >> "api") isEqualTo 1);
    private _onlyServer = (getNumber (_config >> "onlyServer") isEqualTo 1);
    if (((toLower _name) find "serverinit") > -1) then {
        _onlyServer = true;
    };

    private _functionName = format [(["%1_%2_fnc_%3", "%1_fnc_%3"] select _api), _modName, _moduleName, _name];
    private _folderPath = format ["%1\%2\fn_%3.sqf", _modPath, _modulePath, _name];

    parsingNamespace setVariable [_functionName + "_data", [_folderPath, format ["%1/%2", _modName, _moduleName], _onlyServer, _modName]];
    GVAR(allFunctionNamesCached) pushBackUnique _functionName;
    DUMP("Function Found: " + _functionName + " in Path: " + _folderPath + " isServer: " + str _onlyServer)
};


DUMP("--------------------------Start CLib Function Search---------------------------------")
{
    (_x splitString "/") params ["_modName", "_moduleName"];
    private _modPath = getText (configFile >> "CfgCLibModules" >> _modName >> "path");

    {
        [_modPath, _modName, _moduleName, [_moduleName], _x] call _fnc_checkNext;
        nil
    } count (configProperties [configFile >> "CfgCLibModules" >> _modName >> _moduleName, "isClass _x", true]);

    nil
} count (parsingNamespace getVariable QGVAR(allModuleNamesCached));
parsingNamespace setVariable [QCGVAR(allFunctionNamesCached), GVAR(allFunctionNamesCached)];
DUMP("--------------------------End CLib Function Search---------------------------------")
