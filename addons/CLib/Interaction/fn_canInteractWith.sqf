#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    check if a Unit can Interact with a Target

    Parameter(s):
    0: Unit <Object>
    1: Igonred Types <Array>

    Returns:
    <Bool> can InterActWith
*/
params [["_caller", objNull, [objNull]], ["_target", objNull, [objNull]], ["_ignoredTypes", [], [[]]]];
[format [QGVAR(canInteractWith_%1_%2_%3), _caller, _target, _ignoredTypes], {
    scopeName "canInteractWithScope";
    params [["_caller", objNull, [objNull]], ["_target", objNull, [objNull]], ["_ignoredTypes", [], [[]]]];
    {
        _x params ["_type", "_condition"];
        if !(_type in _ignoredTypes) then {
            private _status = call _condition;
            if (!isNil "_status" && {!_status}) then {
                false breakOut "canInteractWithScope";
            };
        };
        nil
    } count GVAR(canInteractWithTypes);
    true
}, _this, 1, QGVAR(clearCanInteractWith)] call CFUNC(cachedCall);
