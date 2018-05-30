#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init

    Parameter(s):
    None

    Returns:
    None
*/

if (isServer) then {
    GVAR(loadoutsNamespace) = true call CFUNC(createNamespace);
    publicVariable QGVAR(loadoutsNamespace);

    GVAR(defaultLoadoutValues) = configProperties [configFile >> "CfgCLibLoadoutsClassBase", "true", true];
    GVAR(defaultLoadoutValues) = GVAR(defaultLoadoutValues) apply {toLower (configName _x)};
    publicVariable QGVAR(defaultLoadoutValues);
};

[{
    {
        {
            (configName _x) call CFUNC(loadLoadout);
            nil
        } count configProperties [_x >> "CfgCLibLoadouts", "isClass _x", true];
        nil
    } count [missionConfigFile >> "CLib", configFile];
    GVAR(loadoutsLoaded) = true;
}, {
    !isNil QGVAR(defaultLoadoutValues) && !isNil QGVAR(loadoutsNamespace)
}] call CFUNC(waitUntil);
