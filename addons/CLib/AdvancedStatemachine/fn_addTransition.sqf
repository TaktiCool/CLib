#include "macros.hpp"
/*
    Community Lib - CLib

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

if (_sourceState isEqualType "String") then {
    _sourceState = [_sourceState];
};

private _transitions = _statemachine getVariable [TRANSITIONS(_x), []];

{
    _transitions pushBack [_name, _condition, _destinationState, _action];
} count _sourceState;

_statemachine setVariable [TRANSITIONS(_x), _transitions];
