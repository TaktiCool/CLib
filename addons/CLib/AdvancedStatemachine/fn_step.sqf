#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Runs an atomar step of a statemachine

    Parameter(s):
    0: statemachine <Namespace>

    Returns:
    0: Return <Type>
*/
params ["_statemachine"];

private _instances = _statemachine getVariable [QGVAR(Instances), []];
private _instancePointer = _statemachine getVariable [QGVAR(InstancePointer), 0];
private _nbrInstances = count _instances;

if (_nbrInstances == 0) exitWith {
    private _pfhId = _statemachine getVariable [QGVAR(pfhId), -1];
    if (_pfhId > -1) then {
        _pfhId call CFUNC(removePerFrameHandler);
    };
};

if (_nbrInstances <= _instancePointer) then {
    _instancePointer = 0;
};

(_instances select _instancePointer) params ["_state", "_data"];
(_statemachine getVariable [STATE(_state), [{}, {}, {}]]) params ["_entryAction", "_stateAction", "_exitAction"];
_data call _stateAction;

{
    _x params ["_condition", "_destinationState", "_transitionAction"];
    if (_data call _condition) exitWith {
        (_statemachine getVariable [STATE(_destinationState), [{}, {}, {}]]) params ["_entryAction"];
        _data call _exitAction;
        _data call _transitionAction;
        (_instances select _instancePointer) set [0, _destinationState];
        _data call _entryAction;
        if (_destinationState == "exit") then {
            _instances deleteAt _instancePointer;
        };

        nil;
    };
    nil;
} count ((_statemachine getVariable [TRANSITIONS(_state), []]) + (_statemachine getVariable [TRANSITIONS(''), []]));

_statemachine setVariable [QGVAR(InstancePointer), _instancePointer + 1];
