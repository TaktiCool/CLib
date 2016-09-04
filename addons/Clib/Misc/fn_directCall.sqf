#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: joko // Jonas

    Description:
    Call Funcion Directly and change the Env

    Parameter(s):
    0: Code or Function that called <Code>
    1: Arguments <Any>

    Returns:
    Return of the Function <Any>
*/
params [["_PRA3_code", {}, [{}]], ["_PRA3_arguments", []]];
private "_PRA_return";
if !(canSuspend) exitWith {
    _PRA3_arguments call _PRA3_code;
};
isNil {
    _PRA_return = _PRA3_arguments call _PRA3_code
};
if !(isNil "_PRA_return") then {_PRA_return};
