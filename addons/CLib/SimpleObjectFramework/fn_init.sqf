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

["InventoryOpened", {
    (_this select 0) params ["", "_container", ["_subContainer", objNull]];
    if (_container getVariable [QGVAR(isSimpleObject), false] || _subContainer getVariable [QGVAR(isSimpleObject), false]) exitWith {
        [{
            (findDisplay 602) closeDisplay 0;
            [{
                Clib_Player action ["Gear", objNull];
            }, 1] call CFUNC(wait);
        }, {
            !isNull (findDisplay 602)
        }] call CFUNC(waitUntil);
        _CLib_EventReturn = true;
    };
}] call CFUNC(addEventhandler);
