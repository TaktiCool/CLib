#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    waitUntil a Condition is Done

    Parameter(s):
    0: Code that get Executed if the Conditon is True <Code>
    1: Conditon that get Executed Every Frame <Code>
    2: Paramter <Any>

    Returns:
    None
*/
params [["_callback", {}], ["_condition", {}], ["_args",[]]];
GVAR(waitUntilArray) pushBack [_callback, _condition, _args];
nil
