#include "macros.hpp"
GVAR(allCustomNamespaces) = [];

GVAR(cachedCall) = call FUNC(createNamespace);
if (hasInterface) then {
    Clib_Player setVariable [QGVAR(playerName), profileName, true];
};

if (hasInterface) then {

    // functions for Disable User Input
    DFUNC(onButtonClickEndStr) = {
        closeDialog 0;
        failMission 'LOSER';
        [false] call FUNC(disableUserInput);
    } call FUNC(codeToString);

    DFUNC(onButtonClickRespawnStr) = {
        closeDialog 0;
        forceRespawn Clib_Player;
        [false] call FUNC(disableUserInput);
    } call FUNC(codeToString);

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

diag_log format ["[Clib - Version]: Server Version %1", GVAR(VersionInfo)];
