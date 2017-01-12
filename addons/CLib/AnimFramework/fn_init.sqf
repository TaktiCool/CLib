#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    -

    Parameter(s):
    None

    Returns:
    None
*/

["switchMove", {
    (_this select 0) params ["_unit", "_move"];
    _unit switchMove _move;
}] call CFUNC(addEventHandler);

["playMove", {
    (_this select 0) params ["_unit", "_move"];
    _unit playMove _move;
}] call CFUNC(addEventHandler);

["playMoveNow", {
    (_this select 0) params ["_unit", "_move"];
    _unit playMoveNow _move;
}] call CFUNC(addEventHandler);

["playGesture", {
    (_this select 0) params ["_unit", "_move"];
    _unit playGesture _move;
}] call CFUNC(addEventHandler);
