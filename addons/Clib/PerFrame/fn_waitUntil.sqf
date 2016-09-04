#include "macros.hpp"
/*
 * Author: joko // Jonas
 * waitUntil a Condition is Done
 *
 * Arguments:
 * 0: Code that get Executed if the Conditon is True <Code>
 * 1: Conditon that get Executed Every Frame <Code>
 * 2: Paramter <Any>
 *
 * Return Value:
 * None
 *
 * Example:
 * [{hint "you die"},{alive _this},player] call CFUNC(waitUntil);
 */

params [["_callback", {}], ["_condition", {}], ["_args",[]]];
GVAR(waitUntilArray) pushBack [_callback, _condition, _args];
nil
