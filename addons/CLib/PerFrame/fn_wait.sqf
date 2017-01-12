#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: esteldunedain
    https://github.com/CBATeam/CBA_A3/blob/efa4ee3b13cc6cbf8919656ca847047c12d057e0/addons/common/fnc_waitAndExecute.sqf

    Description:
    wait a time and execute script

    Parameter(s):
    0: Code that get Executed if the Conditon is True <Code>
    1: Time to Wait <Number>
    2: Paramter <Any>

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED

params [["_code", {}], ["_time", 0], ["_args", []]];
GVAR(waitArray) pushBack [_time + time, _code, _args];
GVAR(sortWaitArray) = true;
nil
