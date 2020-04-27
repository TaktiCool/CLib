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
    // functions for disabling user input
    DFUNC(onButtonClickEndStr) = compileFinal (str ({
        closeDialog 0;
        failMission "LOSER";
        [false] call CFUNC(disableUserInput);
    } call CFUNC(codeToString)));

    DFUNC(onButtonClickRespawnStr) = compileFinal (str ({
        closeDialog 0;
        forceRespawn CLib_Player;
        [false] call CFUNC(disableUserInput);
    } call CFUNC(codeToString)));

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

["playerChanged", {
    (_this select 0) params ["_new"];
    if (_new diarySubjectExists "CLib") exitWith {};

    _new createDiarySubject ["CLib", "CLib - Server Mod"];
    _new createDiaryRecord ["CLib", ["Modules", GVAR(textModules)]];
    _new createDiaryRecord ["CLib", ["Mods", GVAR(textMods)]];
}] call CFUNC(addEventhandler);

["missionStarted", {
    if (player diarySubjectExists "CLib") exitWith {};

    player createDiarySubject ["CLib", "CLib - Server Mod"];
    player createDiaryRecord ["CLib", ["Modules", GVAR(textModules)]];
    player createDiaryRecord ["CLib", ["Mods", GVAR(textMods)]];
}] call CFUNC(addEventhandler);
