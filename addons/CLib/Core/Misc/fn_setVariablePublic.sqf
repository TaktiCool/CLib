#include "macros.hpp"
/*
    Community Lib - CLib

    Author: commy2 and CAA-Picard and PabstMirror and joko // Jonas Ported from ACE3
    Description:
    Publish a variable, but wait a certain amount of time before allowing it to be published it again.

    Parameter(s):
    0: Object the variable should be assigned to <Object>
    1: Name of the variable <String>
    2: Value of the variable <Any>
    3: Embargo delay <NUMBER> (Optional. Default: 1)

    Returns:
    None
*/

params ["_object", "_varName", "_value", ["_delay", 1]];

// set value locally
_object setVariable [_varName, _value];

// Exit if in SP - "duh"
if (!isMultiplayer) exitWith {};

// If we are on embargo, exit
if (_object isEqualTo (_object getVariable [format ["CLib_onEmbargo_%1", _varName], objNull])) exitWith {};

// Publish Now and set last update time:
_object setVariable [_varName, _value, true];
_object setVariable [format ["CLib_onEmbargo_%1", _varName], _object];

[{
    params ["_object", "_varName", "_value"];
    if (isNull _object) exitWith {};

    _object setVariable [format ["CLib_onEmbargo_%1", _varName], nil]; //Remove Embargo
    private _curValue = _object getVariable _varName;

    //If value at start of embargo doesn't equal current, then broadcast and start new embargo
    if (!(_value isEqualTo _curValue)) then {
        [_object, _varName, _curValue] call CFUNC(setVariablePublic);
    };
}, _delay, _this] call CFUNC(wait);
