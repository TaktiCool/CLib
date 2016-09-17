#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    this function read all Modules and functions and build the base of CLib and other modules that build on it

    Parameter(s):
    None

    Returns:
    None
*/
#ifndef isDev
    if (isNil {parsingNamespace getVariable QGVAR(allFunctionNamesCached)}) exitWith {};
#endif
GVAR(allFunctionNamesCached) = [];

private _fnc_readFunction = {
    params ["_modPath", "_modName", "_moduleName", "_config"];

    private _name = configName _config;
    private _api = getNumber (_config >> "api") isEqualTo 1;
    private _onlyServer = getNumber (_config >> "onlyServer") isEqualTo 1;
    if ((toLower _name) find "_fnc_serverinit" < 0) then {
        _onlyServer = true;
    };

    private _functionName = format [(["%1_%2_fnc_%3", "%1_fnc_%3"] select _api), _modName, _moduleName, _name];
    private _folderPath = format ["%1\%2\fn_%3.sqf", _modPath, _moduleName, _name];

    parsingNamespace setVariable [_functionName + "_data", [_folderPath, format ["%1/%2", _modName, _moduleName], _onlyServer]];
    GVAR(allFunctionNamesCached) pushBackUnique _functionName;
    DUMP("Function Found: " + _functionName + " in Path: " + _folderPath)
};


DUMP("--------------------------Start CLib Function Search---------------------------------");
{
    (_x splitString "/") params ["_modName", "_moduleName"];
    private _modPath = getText (configFile >> "CfgCLibModules" >> _modName >> "path");

    {
        private _children = configProperties [_x, "isClass _x", true];
        if (_children isEqualTo []) then {
            [_modPath, _modName, _moduleName, _x] call _fnc_readFunction;
        } else {
            DUMP("SubModule Found: " + configName _x)
            {
                [_modPath, _modName, _moduleName, _x] call _fnc_readFunction;
                nil
            } count _children;
        };

        nil
    } count (configProperties [configFile >> "CfgCLibModules" >> _modName >> _moduleName, "isClass _x", true]);

    nil
} count GVAR(allModuleNamesCached);
parsingNamespace setVariable [QGVAR(allFunctionNamesCached), GVAR(allFunctionNamesCached)];
DUMP("--------------------------End CLib Function Search---------------------------------");
