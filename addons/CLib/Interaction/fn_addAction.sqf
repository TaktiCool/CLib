#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion edit By Joko

    Description:
    Add an action to an object or type(s) of object(s).

    Parameter(s):
    0: the title of the action. <String, Code>
    1: the object (type) which the action should be added to. <Object, Array, String>
    2: the distance in which the action is visible. <Number>
    3: the condition which is evaluated on every frame (if player is in range) to determine whether the action is visible. <String, Code>
    4: the callback which gets called when the action is activated. <Code>
    5: the arguments which get passed to the callback. <Array> (Default: [])

    0: the title of the action. <String, Code>
    1: the object (type) which the action should be added to. <Object, Array, String>
    2: the distance in which the action is visible. <Number>
    3: the condition which is evaluated on every frame (if player is in range) to determine whether the action is visible. <String, Code>
    4: the callback which gets called when the action is activated. <Code>
    5: optional named parameters e.g. ["parameterName", parameterValue, ...] <Array>
        Available parameter:
        "arguments": the arguments which get passed to the callback. (Default: []) <Array>
        "priority": the priority of the action. (Default: 1.5) <Number>
        "showWindow": (Default: true) <Boolean>
        "hideOnUse": (Default: true) <Boolean>
        "shortcut": (Default: "") <String>
        "radius": Distance in meters the unit activating the action must be within to activate it. -1 disables this radius. (Default: 15) <Number>
        "unconscious": if true will be shown to incapacitated player (see setUnconscious, lifeState). (Default: false) <Boolean>
        "onActionAdded": Code which will be executed when action was added. (params: _id, _target, _arguments) <Code>
        "ignoredCanInteractConditions": specifies, which interact conditions will be ignored. (Default: []) <Array>

    Returns:
    None
*/
params ["_text", "_onObject", "_distance", "_condition", "_callback", ["_dynamicArguments",[]]];

private _args = [];
private _priority = 1.5;
private _showWindow = true;
private _hideOnUse = true;
private _shortcut = "";
private _radius = 15;
private _unconscious = false;
private _onActionAdded = {};
private _ignoredCanInteractConditions = [];

private _argName = "";
{
    if (_argName == "") then {
        _argName = _x;
    } else {
        switch (_argName) do {
            case ("arguments"): {
                _args = _x;
            };
            case ("priority"): {
                _priority = _x;
            };
            case ("showWindow"): {
                _showWindow = _x;
            };
            case ("hideOnUse"): {
                _hideOnUse = _x;
            };
            case ("shortcut"): {
                _shortcut = _x;
            };
            case ("radius"): {
                _radius = _x;
            };
            case ("unconscious"): {
                _unconscious = _x;
            };
            case ("onActionAdded"): {
                _onActionAdded = _x;
            };
            case ("ignoredCanInteractConditions"): {
                _ignoredCanInteractConditions = _x;
            };
        };
        _argName = "";
    };
} count _dynamicArguments;


GVAR(currentActionID) = GVAR(currentActionID) + 1;
// Convert Condition to String
_condition = _condition call CFUNC(codeToString);

_condition = "[_target, _this, " + str _ignoredCanInteractConditions + "] call "+ QCFUNC(canInteractWith) + " && " + _condition;

_condition = if (_distance > 0 && !(_onObject isEqualTo CLib_Player)) then {"[_target, " + (str _distance) + "] call " + QCFUNC(inRange) + " &&" + _condition} else {_condition};

_callback = _callback call CFUNC(codeToString);
_callback = compile (format ["[{%1}, _this] call %2;", _callback, QCFUNC(directCall)]);
if (_text isEqualType "") then {_text = compile ("format [""" + _text + """]")};
if (_onObject isEqualType "") then {_onObject = [_onObject];};

if (_onObject isEqualType []) then {
    {
        GVAR(Interaction_Actions) pushBackUnique [_x, _text, _condition, _callback, _args, _priority, _showWindow, _hideOnUse, _shortcut, _radius, _unconscious, _onActionAdded, GVAR(currentActionID)];
        false
    } count _onObject;
};

if (_onObject isEqualType objNull) then {
    if (_onObject isEqualTo CLib_Player) then {
        if (_text isEqualType {}) then {
            _text = call _text;
        };
        if (_text call CFUNC(isLocalised)) then {
            _text = _text call CFUNC(readLocalisation);
        };
        private _argArray = [_text, _callback, _args, _priority, _showWindow, _hideOnUse, _shortcut, _condition, _radius, _unconscious];
        private _id = _onObject addAction _argArray;
        [_id, _onObject, _argArray] call _onActionAdded;
        GVAR(PlayerInteraction_Actions) pushBackUnique [_id, _text, _condition, _callback, _args, _priority, _showWindow, _hideOnUse, _shortcut, _radius, _unconscious, _onActionAdded, GVAR(currentActionID)];
    } else {
        GVAR(Interaction_Actions) pushBackUnique [_onObject, _text, _condition, _callback, _args, _priority, _showWindow, _hideOnUse, _shortcut, _radius, _unconscious, _onActionAdded, GVAR(currentActionID)];
    };
    DUMP("addAction to " + str _onObject)
};
