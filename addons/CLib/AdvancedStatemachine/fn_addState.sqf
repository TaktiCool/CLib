#include "macros.hpp"
/*
    Arma At War

    Author: BadGuy

    Description:
    Adds a state to the statemachine

    Parameter(s):
    0: statemachine <Namespace>
    1: state <String>
    2: entry action <Code>
    3: state action <Code>
    4: exit action <Code>

    Returns:
    -
*/
params ["_statemachine", "_state", ["_entryAction", {}], ["_stateAction", {}], ["_exitAction", {}]];

_statemachine setVariable [STATE(_state), [_entryAction, _stateAction, _exitAction]];
