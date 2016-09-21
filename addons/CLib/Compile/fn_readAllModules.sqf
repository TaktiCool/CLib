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
GVAR(allModuleNamesCached) = [];

DUMP("--------------------------Start CLib Module Search---------------------------------");
{
    private _modName = configName _x;
    DUMP("Mod Found: " + _modName)

    {
        private _moduleName = configName _x;
        private _fullModuleName = format ["%1/%2", _modName, _moduleName];
        parsingNamespace setVariable [format [QGVAR(%1_dependency), _fullModuleName], getArray (_x >> "dependency")];
        GVAR(allModuleNamesCached) pushBackUnique _fullModuleName;

        DUMP("Module Found: " + _moduleName)

        nil
    } count configProperties [_x, "isClass _x", true];

    nil
} count configProperties [configFile >> "CfgCLibModules", "isClass _x", true];
DUMP("--------------------------End CLib Module Search---------------------------------");
