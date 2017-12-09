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

GVAR(allCustomNamespaces) = [];

GVAR(cachedCall) = call CFUNC(createNamespace);
if (hasInterface) then {
    CLib_Player setVariable [QGVAR(playerName), profileName, true];
};

if (hasInterface) then {
    // functions for disabling user input
    DFUNC(onButtonClickEndStr) = {
        closeDialog 0;
        failMission "LOSER";
        [false] call CFUNC(disableUserInput);
    } call CFUNC(codeToString);

    DFUNC(onButtonClickRespawnStr) = {
        closeDialog 0;
        forceRespawn CLib_Player;
        [false] call CFUNC(disableUserInput);
    } call CFUNC(codeToString);

    // this fixes an issue that static guns and cars don't have proper damage on lower LODs meaning that you can't hit a unit in a static gun.
    // this fixes the issue until BI fixes this issue and prevents false reports
    GVAR(staticVehicleFix) = [];
    ["entityCreated", {
        params ["_args"];
        if ([_args, ["Car", "StaticWeapon"]] call CFUNC(isKindOfArray)) then {
            private _id = GVAR(staticVehicleFix) pushBackUnique _args;
            if (_id != -1) then {
                [{}, {
                    1 preloadObject _this;
                }, _args] call CFUNC(waitUntil);
            };
        };
        GVAR(staticVehicleFix) = GVAR(staticVehicleFix) - [objNull];
    }] call CFUNC(addEventhandler);
};
