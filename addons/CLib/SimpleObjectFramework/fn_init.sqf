#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init of SimpleObjectFramework

    Parameter(s):
    None

    Returns:
    None
*/
if (isServer) then {
    GVAR(namespace) = true call CFUNC(createNamespace); // we need a Global Namespace because Only the Server have the Mod Config Classes
    {
        {
            _x call CFUNC(readSimpleObjectComp);
            nil
        } count (configProperties [_x >> "CfgCLibSimpleObject", "isClass _x", true]);
        nil
    } count [configFile, campaignConfigFile, missionConfigFile];
    publicVariable QGVAR(namespace);
};
