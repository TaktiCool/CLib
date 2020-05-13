#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Adds a Status Effect Type to the System

    Parameter(s):
    0: Unit <Object> (Default: objNull)
    1: Status effect id <String> (Default: "")
    2: Reason <String> (Default: "unknown")
    3: Parameter <Anything> (Default: [])

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_unit", objNull, [objNull]],
    ["_id", "", [""]],
    ["_reason", "", [""]],
    ["_parameter", [], []]
];

if (isNull _unit) exitWith {
    LOG("Invalid unit passed to setStatusEffect");
};

if (_id == "") exitWith {
    LOG("Invalid id passed to setStatusEffect");
};

if (_reason == "") exitWith {
    LOG("Empty reason passed to setStatusEffect");
};

private _parametersVarName = format [QGVAR(Parameters_%1), _id];
private _reasonVarName = format [QGVAR(Reasons_%1), _id];

private _allParameters = _unit getVariable [_parametersVarName, []];
private _allReasons = _unit getVariable [_reasonVarName, []];

private _index = _allReasons pushBackUnique _reason;
if (_index < 0) then {
    _index = _allReasons find _reason;
};
if (_index < 0) exitWith {};

_allParameters set [_index, _parameter];

_unit setVariable [_parametersVarName, _allParameters];
_unit setVariable [_reasonVarName, _allReasons];

private _code = GVAR(StatusEffectsNamespace) getVariable [QGVAR(Code_) + _id, []];
[_unit, _allParameters] call _code;
