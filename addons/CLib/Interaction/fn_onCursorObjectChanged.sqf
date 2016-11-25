#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    call for Interaction System that only get called if the Cursortarget Changes

    Parameter(s):
    cursortargetChanged Event Return

    Returns:
    None
*/

(_this select 0) params ["_target"];
if (isNull _target || !(simulationEnabled _target)) exitWith {};

private _actionIDs = _target getVariable [QGVAR(ActionIDs), []];
private _currentID = _actionIDs param [(count _actionIDs) - 1, -999];
if (_currentID isEqualTo GVAR(currentActionID)) exitWith {};
{
    _x params ["_onObject", "_text", "_condition", "_code", "_args", "_priority", "_showWindow", "_hideOnUse", "_shortcut", "_radius", "_unconscious", "_onActionAdded", "_actionID"];

    if (_text isEqualType {}) then {
        _text = call _text;
    };

    if (_text call CFUNC(isLocalised)) then {
        _text = _text call CFUNC(readLocalisation);
    };

    if !(_actionID in _actionIDs) then {
        if (_onObject isEqualType "") then {
            if (_target isKindOf _onObject) then {
                private _argArray = [_text, _code, _args, _priority, _showWindow, _hideOnUse, _shortcut, _condition, _radius, _unconscious];
                private _id = _target addAction _argArray;
                [_id, _target, _argArray] call _onActionAdded;
                _actionIDs pushBackUnique _actionID;
                DUMP("add Real Action to Object " + str _target + " " + str _text)
            };
        };

        if (_onObject isEqualType objNull) then {
            if (_target == _onObject) then {
                private _argArray = [_text, _code, _args, _priority, _showWindow, _hideOnUse, _shortcut, _condition, _radius, _unconscious];
                private _id = _target addAction _argArray;
                [_id, _target, _argArray] call _onActionAdded;
                _actionIDs pushBackUnique _actionID;
                DUMP("add Real Action to Object " + str _target + " " + str _text)
            };
        };
    };
    nil
} count GVAR(Interaction_Actions);

_target setVariable [QGVAR(ActionIDs), _actionIDs];
