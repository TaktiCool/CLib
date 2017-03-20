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

GVAR(loadoutsNamespace) = false call CFUNC(createNamespace);

if (isServer) then {
    GVAR(defaultLoadoutValues) = configProperties [configFile >> "CfgCLibLoadoutsClassBase", "true", true];
    GVAR(defaultLoadoutValues) = GVAR(defaultLoadoutValues) apply {toLower (configName _x)};
    publicVariable QGVAR(defaultLoadoutValues);

    ["registerClientToServerForLoadout", {
        (_this select 0) params ["_unit", "_knownLoadouts"];
        private _data = [];
        {
            if !(_x in _knownLoadouts) then {
                _data pushBack [_x, GVAR(loadoutsNamespace) getVariable _x];
            };
            nil
        } count (call CFUNC(getAllLoadouts));
        ["registerServerConfigLoadout", owner _unit, _data] call CFUNC(targetEvent);
    }] call CFUNC(addEventhandler);
};

[{
    {
        {
            (configName _x) call CFUNC(loadLoadout);
            nil
        } count configProperties [_x >> "CfgCLibLoadouts", "isClass _x", true];
        nil
    } count [missionConfigFile >> "CLib", configFile];

    if (isMultiplayer) then {
        ["registerClientToServerForLoadout", [CLib_Player, [GVAR(loadoutsNamespace), QGVAR(allLoadouts)] call CFUNC(allVariables)]] call CFUNC(serverEvent);
    };
}, {
    !isNil QGVAR(defaultLoadoutValues)
}] call CFUNC(waitUntil);

["registerServerConfigLoadout", {
    params ["_data"];
    {
        _x params ["_name", "_loadout"];
        [GVAR(loadoutsNamespace), _name, _loadout, QGVAR(allLoadouts)] call CFUNC(setVariable);
        nil
    } count _data;
}] call CFUNC(addEventhandler);
