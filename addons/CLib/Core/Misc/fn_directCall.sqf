#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Calls a funcion directly and changes the Environment to Unscheduled

    Parameter(s):
    0: Code or Function that gets called <Code> (Default: {})
    1: Arguments <Anything> (Default: [])

    Returns:
    Return of the Function <Anything>
*/

params [
    ["_CLib_code", {}, [{}]],
    ["_CLib_arguments", [], []]
];

if !(canSuspend) exitWith {
    _CLib_arguments call _CLib_code;
};
private "_CLib_return";
isNil {
    _CLib_return = _CLib_arguments call _CLib_code
};
if !(isNil "_CLib_return") then {_CLib_return};
