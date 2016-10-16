#include "macros.hpp"
/*
        Comunity Lib - CLib

    Author: NetFusion

    Description:
    Continuously checks whether an action should be added to the cursorTarget.

    Parameter(s):
    -

    Remarks:
    * Should only be called once per mission.

    Returns:
    -

    Example:
    true call CFUNC(loop);
*/
(_this select 0) params ["_lastTarget"];
if (isNull _lastTarget) exitWith {};
private _objActions = _lastTarget getVariable [QGVAR(Interaction_Actions), []];
if (_objActions isEqualTo GVAR(Interaction_Actions)) exitWith {};
{
    _x params ["_onObject", "_text", "_condition", "_code", "_args", "_priority", "_showWindow", "_hideOnUse", "_shortcut", "_radius", "_unconscious", "_onActionAdded"];

    if (_text isEqualType {}) then {
        _text = call _text;
    };

    if (_text call CFUNC(isLocalised)) then {
        _text = _text call CFUNC(readLocalisation);
    };

    if !(_x in _objActions) then {
        if (_onObject isEqualType "") then {
            if (_lastTarget isKindOf _onObject) then {
                private _argArray = [_text, _code, _args, _priority, _showWindow, _hideOnUse, _shortcut, _condition, _radius, _unconscious];
                private _id = _lastTarget addAction _argArray;
                [_id, _lastTarget, _argArray] call _onActionAdded;
                _objActions pushBackUnique _x;
                DUMP("add Real Action to Object " + str _lastTarget)
            };
        };

        if (_onObject isEqualType objNull) then {
            if (_lastTarget == _onObject) then {
                private _argArray = [_text, _code, _args, _priority, _showWindow, _hideOnUse, _shortcut, _condition, _radius, _unconscious];
                private _id = _lastTarget addAction _argArray;
                [_id, _lastTarget, _argArray] call _onActionAdded;
                _objActions pushBackUnique _x;
                DUMP("add Real Action to Object " + str _lastTarget)
            };
        };
    };
    nil
} count GVAR(Interaction_Actions);

_lastTarget setVariable [QGVAR(Interaction_Actions), _objActions];
