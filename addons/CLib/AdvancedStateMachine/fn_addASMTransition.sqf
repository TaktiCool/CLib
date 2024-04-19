#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Adds a transition

    Parameter(s):
    0: State machine <Location> (Default: locationNull)
    1: Source state names <Array, String> (Default: [])
    2: Destination state name <String> (Default: "")
    3: Condition <Code> (Default: {true})
    4: Action <Code> (Default: {})

    Returns:
    None
*/

params [
    ["_stateMachine", locationNull, [locationNull]],
    ["_sourceStateNames", [], [[], ""], []],
    ["_destinationStateName", "", [""]],
    ["_condition", {true}, [{}]],
    ["_action", {}, [{}]]
];

if (isNull _stateMachine) exitWith {
    LOG("Invalid state machine passed to addASMTransition");
};

if (_destinationStateName == "") exitWith {
    LOG("Invalid destination state name passed to addASMTransition");
};

if (_sourceStateNames isEqualType "") then {
    _sourceStateNames = [_sourceStateNames];
};

{
    if (_x isEqualType "") then {
        private _transitions = _stateMachine getVariable [TRANSITIONS(_x), []];
        _transitions pushBack [_condition, _destinationStateName, _action];
        _statemachine setVariable [TRANSITIONS(_x), _transitions];
    } else {
        LOG("Invalid source state name passed to addASMTransition");
    };
} forEach _sourceStateNames;
