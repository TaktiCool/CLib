#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    This function creates an post processor effect.

    Parameter(s):
    0: Determines which kind of effect is created <String>
    1: On which layer should the effect be visible <Number>
    2: The initial parameters for the effect <Array>

    Returns:
    A handle for the created effect <Number>
*/


private "_effect";

params ["_type", "_layer", "_default"];

// Create the effect and apply the initial parameters.
_effect = ppEffectCreate [_type, _layer];
_effect ppEffectForceInNVG true;
_effect ppEffectAdjust _default;
_effect ppEffectCommit 0;

// Return the handle.
_effect
