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
private _allModulesNames = [];
DUMP("--------------------------Start CLib Module Search---------------------------------")
{
    private _modName = configName _x;
    DUMP("Mod Found: " + _modName)

    {
        private _moduleName = configName _x;
        private _fullModuleName = format ["%1/%2", _modName, _moduleName];
        parsingNamespace setVariable [format [QCGVAR(%1_dependency), _fullModuleName], getArray (_x >> "dependency")];
        _allModulesNames pushBackUnique _fullModuleName;

        DUMP("Module Found: " + _moduleName)

        nil
    } count configProperties [_x, "isClass _x", true];

    nil
} count configProperties [configFile >> "CfgCLibModules", "isClass _x", true];
DUMP("allModuleNamesCached: " + str _allModulesNames)
parsingNamespace setVariable [QGVAR(allModuleNamesCached), _allModulesNames];
DUMP("--------------------------End CLib Module Search---------------------------------")
