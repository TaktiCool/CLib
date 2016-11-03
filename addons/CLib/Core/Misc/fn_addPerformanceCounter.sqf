#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    [Description]

    Parameter(s):
    0: Name of Counter <String>
    1: Toggle <Bool>

    Returns:
    None
*/
params ["_name", "_enable"];

private _variableName = format [QGVAR(PerformanceTimerTickTime_%1), _name];

if (_enable) then {
    missionNamespace setVariable [_variableName, diag_tickTime];
} else {
    private _oldTime = missionNamespace getVariable [_variableName, -99999];
    private _newTime = diag_tickTime;
    private _diff = (_newTime - _oldTime)*1000;
    diag_log format ["[CLib: Performance Counter] %1: Started %2 s; Ended %3 s; Run time %4 ms;", _name, _oldTime, _newTime, _diff];
    systemChat format ["[CLib: Performance Counter] %1: Started %2 s; Ended %3 s; Run time %4 ms;", _name, _oldTime, _newTime, _diff];
    missionNamespace setVariable [_variableName, nil];
};
