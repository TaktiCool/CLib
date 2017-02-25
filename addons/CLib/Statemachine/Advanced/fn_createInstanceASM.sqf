#include "macros.hpp"
/*
    Arma At War

    Author: BadGuy

    Description:
    Creates an instance of a statemachine

    Parameter(s):
    0: statemachine <Namespace>
    1: data <Any>
    2: initial state <String>

    Returns:
    -
*/
params ["_statemachine", "_data", ["_initialState", "initial"]];
private _instances = _statemachine getVariable [QGVAR(Instances), []];
_instances pushBack [_initialState, _data];
_statemachine setVariable [QGVAR(Instances), _instances];

if ((_statemachine getVariable [QGVAR(pfhId), -1]) == -1) then {
    _statemachine setVariable [QGVAR(pfhId), [{
        params ["_statemachine", "_id"];
        [_statemachine] call FUNC(stepASM)
    }, 0, _statemachine] call CFUNC(addPerFrameHandler)];
};
