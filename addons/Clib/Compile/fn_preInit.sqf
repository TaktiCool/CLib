#include "macros.hpp"

if (isNil QFUNC(compile)|| isNil QFUNC(compressString) || isNil QFUNC(decompressString) || isNil QFUNC(stripSqf)) then {
    DFUNC(compile) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(compile));
    DFUNC(compressString) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(compressString));
    DFUNC(decompressString) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(decompressString));
    DFUNC(stripSqf) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(stripSqf));
};

GVAR(VersionInfo) = [getText (configFile >> "CfgPatches" >> QPREFIX >> "versionStr")];
publicVariable QGVAR(VersionInfo);

// The autoloader uses this array to get all function names.
GVAR(functionCache) = [];
call CFUNC(readAllModulesAndFunctions);

// We call the autoloader here. This starts the mod work.
call FUNC(autoloadEntryPoint);
