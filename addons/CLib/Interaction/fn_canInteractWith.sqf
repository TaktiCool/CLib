#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Check whether a unit can interact with a target

    Parameter(s):
    0: Unit <Object> (Default: objNull)
    1: Target <Object> (Default: objNull)
    2: Igonred Types <Array> (Default: [])

    Returns:
    If unit can interact with target <Bool>
*/

params [
    ["_caller", objNull, [objNull]],
    ["_target", objNull, [objNull]],
    ["_ignoredTypes", [], [[]], []]
];

[format [QGVAR(canInteractWith_%1_%2_%3), _caller, _target, _ignoredTypes], {
    scopeName "canInteractWithScope";

    params [
        ["_caller", objNull, [objNull]],
        ["_target", objNull, [objNull]],
        ["_ignoredTypes", [], [[]], []]
    ];

    {
        _x params ["_type", "_condition"];
        if !(_type in _ignoredTypes) then {
            private _status = [_caller, _target] call _condition;
            if (!isNil "_status" && {!_status}) then {
                false breakOut "canInteractWithScope";
            };
        };
        nil
    } count GVAR(canInteractWithTypes);
    true
}, _this, 1, QGVAR(clearCanInteractWith)] call CFUNC(cachedCall);
