#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    This function creates an post processor effect.

    Parameter(s):
    0: Determines which kind of effect is created <String> (Default: "")
    1: On which layer should the effect be visible <Number> (Default: 0)
    2: The initial parameters for the effect <Array> (Default: [])

    Returns:
    A handle for the created effect <Number>
*/

if (!hasInterface) exitWith {};

params [
    ["_type", "", [""]],
    ["_layer", 0, [0]],
    ["_settings", [], [[]], []]
];

// Create the effect and apply the initial parameters.
private _effect = ppEffectCreate [_type, _layer];
_effect ppEffectForceInNVG true;
_effect ppEffectAdjust _settings;
_effect ppEffectCommit 0;

// Return the handle.
_effect
