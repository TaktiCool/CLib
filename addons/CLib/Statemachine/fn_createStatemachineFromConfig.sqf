#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Create Statemachine from Config

    Parameter(s):
    0: Config Path <Config>

    Returns:
    0: Statemachine Object <Location>
*/
params ["_configPath"];

private _stateMachine = call CFUNC(createStatemachine);

private _entryPoint = getText(_configPath >> "entryPoint");
if (_entryPoint != "") then {
    _stateMachine setVariable [SMSVAR(nextStateData), _entryPoint];
};

{
    private _code = getText(_x >> "stateCode");
    private _name = configName _x;
    [_stateMachine, _name, compile _code] call CFUNC(addStatemachineState);
    nil
} count ([_configPath, "isClass _x", true] call CFUNC(configProperties));

_stateMachine
