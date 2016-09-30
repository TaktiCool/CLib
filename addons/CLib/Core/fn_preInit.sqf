#include "macros.hpp"
call CFUNC(preStart);
CGVAR(VersionInfo) = [getText (configFile >> "CfgPatches" >> QPREFIX >> "versionStr")];
publicVariable QCGVAR(VersionInfo);

// We call the autoloader here. This starts the mod work.
call FUNC(autoloadEntryPoint);
