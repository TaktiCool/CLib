#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Create Statemachine from Config

    Parameter(s):
    0: Config Path <Config> (Default: configNull)

    Returns:
    Statemachine Object <Location>
*/

params [
    ["_configPath", configNull, [configNull]]
];

private _stateMachine = call CFUNC(createStatemachine);

{
    private _code = getText (_x >> "stateCode");
    private _name = configName _x;
    [_stateMachine, _name, compile _code] call CFUNC(addStatemachineState);
} forEach ([_configPath, "isClass _x", true] call CFUNC(configProperties));

private _entryPoint = getText (_configPath >> "entryPoint");
if (_entryPoint != "") then {
    _stateMachine setVariable [SMSVAR(nextStateData), _entryPoint];
};

if (getNumber (_configPath >> "autostart") isEqualTo 1) then {
    call CFUNC(startStatemachines);
};

_stateMachine
