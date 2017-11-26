#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Adds a state to the state machine

    Parameter(s):
    0: State machine <Location> (Default: locationNull)
    1: State name <String> (Default: "")
    2: Entry action <Code> (Default: {})
    3: State action <Code> (Default: {})
    4: Exit action <Code> (Default: {})

    Returns:
    None
*/

params [
    ["_stateMachine", locationNull, [locationNull]],
    ["_stateName", "", [""]],
    ["_entryAction", {}, [{}]],
    ["_stateAction", {}, [{}]],
    ["_exitAction", {}, [{}]]
];

if (isNull _stateMachine) exitWith {
    LOG("Invalid state machine passed to addASMState");
};

if (_stateName == "" || _stateName == "exit") exitWith {
    LOG("Invalid state name passed to addASMState");
};

_stateMachine setVariable [STATE(_stateName), [_entryAction, _stateAction, _exitAction]];
