#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    PreInit

    Parameter(s):
    None

    Returns:
    None
*/

call CFUNC(preStart);
CGVAR(VersionInfo) = [getText (configFile >> "CfgPatches" >> QPREFIX >> "versionStr")];
publicVariable QCGVAR(VersionInfo);

// We call the autoloader here. This starts the mod work.
call FUNC(autoloadEntryPoint);
