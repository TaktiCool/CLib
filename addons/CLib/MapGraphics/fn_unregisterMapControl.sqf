#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Unregisters a Map Control for MapGraphics

    Parameter(s):
    0: Map <Control> (Default: controlNull)

    Returns:
    None
*/

params [
    ["_map", controlNull, [controlNull]]
];

private _idx = 0;
with uiNamespace do {
    _idx = GVAR(MapGraphicsMapControls) find _map;
};
if (_idx >= 0) then {
    private _drawId = _map getVariable [QGVAR(DrawEHId), -1];
    private _mmId = _map getVariable [QGVAR(MouseMovingEHId), -1];
    private _mcId = _map getVariable [QGVAR(MouseButtonClickEHId), -1];
    private _mdcId = _map getVariable [QGVAR(MouseButtonDblClickEHId), -1];
    _map ctrlRemoveEventHandler ["Draw", _drawId];
    _map ctrlRemoveEventHandler ["MouseMoving", _mmId];
    _map ctrlRemoveEventHandler ["MouseButtonClick", _mcId];
    _map ctrlRemoveEventHandler ["MouseButtonDblClick", _mdcId];
    with uiNamespace do {
        GVAR(MapGraphicsMapControls) deleteAt _idx;
    };
};
