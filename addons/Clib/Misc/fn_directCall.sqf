#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: joko // Jonas

    Description:
    Call Funcion Directly and change the Env

    Parameter(s):
    0: Code or Function that called <Code>
    1: Arguments <Any>

    Returns:
    Return of the Function <Any>
*/
params [["_Clib_code", {}, [{}]], ["_Clib_arguments", []]];
if !(canSuspend) exitWith {
    _Clib_arguments call _Clib_code;
};
private "_Clib_return";
isNil {
    _Clib_return = _Clib_arguments call _Clib_code
};
if !(isNil "_Clib_return") then {_Clib_return};
