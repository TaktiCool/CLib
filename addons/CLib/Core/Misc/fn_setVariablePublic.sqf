#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: commy2, joko // Jonas
    https://github.com/acemod/ACE3/blob/49d4f233d974fd5cc394415b18878ae50963fc98/addons/common/functions/fnc_setVariablePublic.sqf

    Description:
    Publish a variable but wait a certain amount of time before allowing it to be published it again.

    Parameter(s):
    0: Object the variable should be assigned to <Object> (Default: objNull)
    1: Name of the variable <String> (Default: "")
    2: Value of the variable <Anything>
    3: Embargo delay <Number> (Default: 1)

    Returns:
    None
*/

params [
    ["_object", objNull, [objNull]],
    ["_varName", "", [""]],
    "_value",
    ["_delay", 1, [0]]
];

// set value locally
_object setVariable [_varName, _value];

// Exit if in SP - "duh"
if (!isMultiplayer) exitWith {};

// If we are on embargo, exit
if (_object isEqualTo (_object getVariable [format [QGVAR(onEmbargo_%1), _varName], objNull])) exitWith {};

// Publish Now and set last update time:
_object setVariable [_varName, _value, true];
_object setVariable [format [QGVAR(onEmbargo_%1), _varName], _object];

[{
    params ["_object", "_varName", "_value", "_delay"];
    if (isNull _object) exitWith {};

    _object setVariable [format [QGVAR(onEmbargo_%1), _varName], nil]; //Remove Embargo
    private _curValue = _object getVariable _varName;

    //If value at start of embargo doesn't equal current, then broadcast and start new embargo
    if (!(_value isEqualTo _curValue)) then {
        [_object, _varName, _curValue, _delay] call CFUNC(setVariablePublic);
    };
}, _delay, _this] call CFUNC(wait);
