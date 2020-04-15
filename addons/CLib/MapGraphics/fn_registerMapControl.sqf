#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Registers a Map Control for MapGraphics

    Parameter(s):
    0: Map <Control> (Default: controlNull)

    Returns:
    None
*/

params [
    ["_map", controlNull, [controlNull]]
];

// make sure that the control not already have a draw function
private _exit = _map in (uiNamespace getVariable [QGVAR(MapGraphicsMapControls), []]);

if (_exit) exitWith {nil};

private _drawEHId = _map ctrlAddEventHandler ["Draw", {_this call CFUNC(drawMapGraphics)}];
private _mmEHId = _map ctrlAddEventHandler ["MouseMoving", {_this call CFUNC(mapGraphicsMouseMoving)}];
private _mcEHId = _map ctrlAddEventHandler ["MouseButtonClick", {[_this, "clicked"] call CFUNC(mapGraphicsMouseButtonClick)}];
private _mdcEHId = _map ctrlAddEventHandler ["MouseButtonDblClick", {_this call CFUNC(mapGraphicsMouseButtonDblClick)}];
private _mbdEHId = _map ctrlAddEventHandler ["MouseButtonDown", {[_this, "down"] call CFUNC(mapGraphicsMouseButtonClick)}];
private _mbuEHId = _map ctrlAddEventHandler ["MouseButtonUp", {[_this, "up"] call CFUNC(mapGraphicsMouseButtonClick)}];

_map setVariable [QGVAR(DrawEHId), _drawEHId];
_map setVariable [QGVAR(MouseMovingEHId), _mmEHId];
_map setVariable [QGVAR(MouseButtonClickEHId), _mcEHId];
_map setVariable [QGVAR(MouseButtonDblClickEHId), _mdcEHId];
_map setVariable [QGVAR(MouseButtonDownEHId), _mdcEHId];
_map setVariable [QGVAR(MouseButtonUpEHId), _mdcEHId];

with uiNamespace do {
    GVAR(MapGraphicsMapControls) pushBackUnique _map;
};

nil
