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
private _allModulesNames = [];
DUMP("--------------------------Start CLib Module Search---------------------------------")
private _allMods = configProperties [configFile >> "CfgCLibModules", "isClass _x", true];
_allMods = _allMods apply { toLower (configName _x); };
parsingNamespace setVariable [QGVAR(allModsNamesCached), _allMods];
{
    private _modName = _x;
    DUMP("Mod Found: " + _modName)
    private _modModules = configProperties [configFile >> "CfgCLibModules" >> _modName, "isClass _x", true];
    _modModules = _modModules apply { toLower (configName _x); };
    private _modDependency = (getArray (configFile >> "CfgCLibModules" >>_modName >> "dependency")) apply { toLower _x; };
    parsingNamespace setVariable [format [QCGVAR(%1_ModModules), _modName], _modModules];
    {
        private _moduleName = _x;
        private _fullModuleName = format ["%1/%2", _modName, _moduleName];
        private _dependency = (getArray (configFile >> "CfgCLibModules" >>_modName >> _moduleName >> "dependency")) apply { toLower _x; };
        _dependency append _modDependency;
        parsingNamespace setVariable [format [QCGVAR(%1_dependency), _fullModuleName], _dependency];
        _allModulesNames pushBackUnique _fullModuleName;

        DUMP("Module Found: " + _moduleName)

        nil
    } count _modModules;
    nil
} count _allMods;

// Update Mod Dependency
{
    private _varName = format [QCGVAR(%1_dependency), _x];
    private _dependency = parsingNamespace getVariable _varName;
    {
        private _mod = _x;
        if (_x in _dependency) then {
            private _modModules = parsingNamespace getVariable (format [QCGVAR(%1_ModModules), _x]);
            {
                _dependency pushBackUnique format ["%1/%2", _mod, _x];
                nil
            } count _modModules;
            _dependency = _dependency - [_x];
            DUMP("Update Module Dependency with Mod: " + _x + " " + str _dependency)
        };
        nil
    } count _allMods;
    parsingNamespace setVariable [_varName, _dependency];
    nil
} count _allModulesNames;

parsingNamespace setVariable [QGVAR(allModuleNamesCached), _allModulesNames];
DUMP("allModuleNamesCached: " + str _allModulesNames)
DUMP("--------------------------End CLib Module Search---------------------------------")
