#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Registers a Map Control for MapGraphics

    Parameter(s):
    0: Map <Control>

    Returns:
    None
*/
params ["_map"];
private _exit = false;
// make sure that the control not already have a draw function
with uiNamespace do {
    _exit = _map in GVAR(MapGraphicsMapControls);
};

if (_exit) exitWith {nil};

private _drawEHId = _map ctrlAddEventHandler ["Draw", CFUNC(drawMapGraphics)];
private _mmEHId = _map ctrlAddEventHandler ["MouseMoving", CFUNC(mapGraphicsMouseMoving)];
private _mcEHId = _map ctrlAddEventHandler ["MouseButtonClick", CFUNC(mapGraphicsMouseButtonClick)];

_map setVariable [QGVAR(DrawEHId), _drawEHId];
_map setVariable [QGVAR(MouseMovingEHId), _mmEHId];
_map setVariable [QGVAR(MouseButtonClickEHId), _mcEHId];

with uiNamespace do {
    GVAR(MapGraphicsMapControls) pushBackUnique _map;
};

nil
