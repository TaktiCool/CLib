#include "macros.hpp"
if (isServer) then {
    GVAR(namespace) = true call CFUNC(createNamespace); // we need a Global Namespace because Only the Server have the Mod Config Classes
    {
        {
            _x call CFUNC(readSimpleObjectComp);
            nil
        } count (configProperties [_x >> "CfgCLibSimpleObject", "isClass _x", true]);
        nil
    } count [missionConfigFile, campaignConfigFile, configFile];
    publicVariable QGVAR(namespace);
};
