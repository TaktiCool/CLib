#include "macros.hpp"
GVAR(loadoutsNamespace) = false call CFUNC(createNamespace);


if (isServer) then {
    GVAR(defaultLoadoutValues) = configProperties [configFile >> "CfgCLibLoadoutsClassBase", "true", true];
    GVAR(defaultLoadoutValues) = GVAR(defaultLoadoutValues) apply {toLower (configName _x)};
    publicVariable QGVAR(defaultLoadoutValues);
};

{
    {
        (configName _x) call CFUNC(loadLoadout);
        nil
    } count configProperties [_x >> "CfgCLibLoadouts", "isClass _x", true];
    nil
} count [missionConfigFile >> "CLib", configFile];

["registerClientToServerForLoadout", {
    (_this select 0) params ["_unit", "_knownLoadouts"];
    private _id = owner _unit;
    private _data = [];
    {
        if !(_x in _knownLoadouts) then {
            _data pushBack [_x, (GVAR(loadoutsNamespace) getVariable _x)];
        };
        nil
    } count [GVAR(loadoutsNamespace), QGVAR(allLoadouts)] call CFUNC(allVariables);
    ["registerServerConfigLoadout", _id , _data] call CFUNC(targetEvent);
}] call CFUNC(addEventhandler);


["registerServerConfigLoadout", {
    params ["_data"];
    {
        [GVAR(loadoutsNamespace), _x select 0, _x select 1, QGVAR(allLoadouts)] call CFUNC(setVariable);
        nil
    } count _data;

}] call CFUNC(addEventhandler);

if (isMultiplayer) then {
    // ["registerClientToServerForLoadout", ([GVAR(loadoutsNamespace), QGVAR(allLoadouts)] call CFUNC(allVariables))] call CFUNC(serverEvent);
};
