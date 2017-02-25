#include "macros.hpp"
/*
    Arma At War

    Author: BadGuy

    Description:
    Adds a transition

    Parameter(s):
    0: statemachine <Namespace>
    1: source state <String>
    2: destination state <String>
    3: name <String>
    4: condition <Code>
    5: action <Code>

    Returns:
    -
*/
params ["_statemachine", "_sourceState", "_destinationState", "_name", ["_condition", {}], ["_action", {}]];

private _transitions = _statemachine getVariable [TRANSITIONS(_sourceState), []];
_transitions pushBack [_name, _condition, _destinationState, _action];
_statemachine setVariable [TRANSITIONS(_sourceState), _transitions];
