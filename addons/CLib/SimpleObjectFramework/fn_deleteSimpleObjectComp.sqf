#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Deletes safly a Previos created Object Composition.

    Parameter(s):
    0: Unique identifier <String> (Default: "")
    1: Callback <Array> (Default: [])

    Returns:
    None

    Remarks:
    Callback Format
        0: Target Object <Object>
        1: Callback Code <Code>
        2: Callback Parameters <Anything>
*/

params [
    ["_uid", "", [""]],
    ["_callback", [], [[]], [[]]]
];

if !(isServer) exitWith {
    [QGVAR(deleteSimpleObjectComp), _this] call CFUNC(serverEvent);
};

private _objs = GVAR(compNamespace) getVariable [_uid, []];

deleteVehicle _objs;

GVAR(compNamespace) setVariable [_uid, nil, true];

if (_callback isNotEqualTo []) then {
    _callback params [["_target", objNull], ["_code", {}], ["_parameter", []]];
    if (_code isNotEqualTo [] || isNull _target) then {
        [QGVAR(simpleObjectsDeleted), _target, [_uid, _code, _parameter]] call CFUNC(targetEvent);
    };
};
