#include "macros.hpp"
/*
    Community Lib - CLib

    Author: EstelDudleDain edit by joko // Jonas

    Description:
    wait a time and execute script

    Parameter(s):
    0: Code that get Executed if the Conditon is True <Code>
    1: Time to Wait <Number>
    2: Paramter <Any>

    Returns:
    None
*/
params [["_code", {}], ["_time", 0], ["_args", []]];
GVAR(waitArray) pushBack [_time + time, _code, _args];
GVAR(sortWaitArray) = true;
