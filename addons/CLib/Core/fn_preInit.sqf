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

// Quick fix for https://feedback.bistudio.com/T123785 - credits to SaMatra
BIS_initRespawn_disconnect = -1;

call CFUNC(preStart);
CGVAR(VersionInfo) = [getText (configFile >> "CfgPatches" >> QPREFIX >> "versionStr")];
publicVariable QCGVAR(VersionInfo);

// We call the autoloader here. This starts the mod work.
call FUNC(autoloadEntryPoint);
