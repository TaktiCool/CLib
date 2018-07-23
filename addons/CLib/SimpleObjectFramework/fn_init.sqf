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
    GVAR(compNamespace) = true call CFUNC(createNamespace);
    GVAR(namespace) = true call CFUNC(createNamespace); // we need a Global Namespace because Only the Server have the Mod Config Classes
    {
        {
            _x call CFUNC(readSimpleObjectComp);
            nil
        } count (configProperties [_x >> "CfgCLibSimpleObject", "isClass _x", true]);
        nil
    } count [configFile, campaignConfigFile, missionConfigFile];
    publicVariable QGVAR(namespace);
    publicVariable QGVAR(compNamespace);
};

GVAR(callbackNamespace) = true call CFUNC(createNamespace);

[QGVAR(simpleObjectsCreated), {
    (_this select 0) params ["_pid", "_objects"];

    private _callbackData = GVAR(callbackNamespace) getVariable [_pid, []];

    if !(_callbackData isEqualTo []) then {
        [_objects] call (_callbackData select 1);
    };

}] call CFUNC(addEventhandler);

[QGVAR(createSimpleObjectComp), {
    (_this select 0) call CFUNC(createSimpleObjectComp);
}] call CFUNC(addEventhandler);

[QGVAR(deleteSimpleObjectComp), {
    (_this select 0) call CFUNC(deleteSimpleObjectComp);
}] call CFUNC(addEventhandler);
