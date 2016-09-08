#include "preInit.sqf"
GVAR(VersionInfo) = [getText (configFile >> "CfgPatches" >> QPREFIX >> "versionStr")];
publicVariable QGVAR(VersionInfo);

// We call the autoloader here. This starts the mod work.
call CFUNC(autoloadEntryPoint);
