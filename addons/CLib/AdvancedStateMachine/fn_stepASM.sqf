#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Runs an atomar step of a state machine

    Parameter(s):
    0: State machine <Location> (Default: locationNull)

    Returns:
    None
*/

params [
    ["_stateMachine", locationNull, [locationNull]]
];

if (isNull _stateMachine) exitWith {
    LOG("Invalid state machine passed to stepASM");
};

private _instances = _stateMachine getVariable [QGVAR(Instances), []];
private _instancePointer = _stateMachine getVariable [QGVAR(InstancePointer), 0];
private _instancesCount = count _instances;

if (_instancesCount == 0) exitWith {
    private _pfhId = _stateMachine getVariable [QGVAR(pfhId), -1];
    if (_pfhId > -1) then {
        _pfhId call CFUNC(removePerFrameHandler);
    };
};

if (_instancesCount <= _instancePointer) then {
    _instancePointer = 0;
};

(_instances select _instancePointer) params ["_stateName", "_data"];
(_stateMachine getVariable [STATE(_stateName), [{}, {}, {}]]) params ["", "_stateAction", "_exitAction"];
_data call _stateAction;

{
    _x params ["_condition", "_destinationStateName", "_transitionAction"];
    if (_data call _condition) exitWith {
        (_stateMachine getVariable [STATE(_destinationStateName), [{}, {}, {}]]) params ["_entryAction"];
        _data call _exitAction;
        _data call _transitionAction;
        (_instances select _instancePointer) set [0, _destinationStateName];
        _data call _entryAction;
        if (_destinationStateName == "exit") then {
            _instances deleteAt _instancePointer;
        };
    };
    nil
} count ((_stateMachine getVariable [TRANSITIONS(_stateName), []]) + (_stateMachine getVariable [TRANSITIONS(""), []]));

_stateMachine setVariable [QGVAR(InstancePointer), _instancePointer + 1];
