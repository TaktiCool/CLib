#include "macros.hpp"
GVAR(allCustomNamespaces) = [];

GVAR(cachedCall) = call CFUNC(createNamespace);
if (hasInterface) then {
    CLib_Player setVariable [QGVAR(playerName), profileName, true];
};

if (hasInterface) then {

    // functions for Disable User Input
    DFUNC(onButtonClickEndStr) = {
        closeDialog 0;
        failMission 'LOSER';
        [false] call CFUNC(disableUserInput);
    } call CFUNC(codeToString);

    DFUNC(onButtonClickRespawnStr) = {
        closeDialog 0;
        forceRespawn CLib_Player;
        [false] call CFUNC(disableUserInput);
    } call CFUNC(codeToString);

    // this fix a issue that Static Guns and Cars dont have right Damage on Lower LODs what mean you can not hit a Unit in a Static gun.
    // this fix the issue until BI fix this issue and prevent False Reports
    GVAR(staticVehicleFix) = [];
    ["entityCreated", {
        params ["_args"];
        if (_args isKindOf "Car" || _args isKindOf "StaticWeapon") then {
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

diag_log format ["[CLib - Version]: Server Version %1", CGVAR(VersionInfo)];
