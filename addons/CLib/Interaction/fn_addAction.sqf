#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion, joko // Jonas

    Description:
    Add an action to an object or types of objects

    Parameter(s):
    0: Title of the action <String, Code> (Default: "MISSING TITLE")
    1: Object or type which the action should be added to <Object, Array, String> (Default: objNull)
    2: Distance in which the action is visible <Number> (Default: 10)
    3: Condition which is evaluated on every frame if player is in range to determine if the action is visible <String, Code> (Default: "true")
    4: Callback which gets called when the action is activated <Code> (Default: {})
    5: Optional named parameters <Array> (Default: [])

    Returns:
    None

    Remarks:
    Named parameters:
        "arguments": Arguments which get passed to the callback <Array> (Default: [])
        "priority": Priority of the action <Number> (Default: 1.5)
        "showWindow": Players see title text in mid screen <Bool> (Default: true)
        "hideOnUse": Hide action menu after use <Bool> (Default: true)
        "shortcut": Key name to add binding for action <String> (Default: "")
        "radius": Distance in meters the unit activating the action must be within to activate it <Number> (Default: 15)
        "unconscious": Visible to incapacitated player <Bool> (Default: false)
        "onActionAdded": Code which will be executed when action was added <Code> (Default: {})
        "ignoredCanInteractConditions": Interact conditions that will be ignored <Array> (Default: [])
        "selection": named selection in Geometry LOD to which the action is attached <String> (Default: "")
        "memoryPoint": memory point on the object to which the action is attached. If parameter selection is supplied, parameter memoryPoint is not used <String> (Default: "")
*/

params [
    ["_text", "MISSING TITLE", ["", {}]],
    ["_target", objNull, [objNull, [], ""], []],
    ["_distance", 10, [0]],
    ["_condition", "true", ["", {}]],
    ["_callback", {}, [{}]],
    ["_dynamicArguments", [], [[]], []]
];

private _args = [];
private _priority = 1.5;
private _showWindow = true;
private _hideOnUse = true;
private _shortcut = "";
private _radius = 15;
private _unconscious = false;
private _onActionAdded = {};
private _ignoredCanInteractConditions = [];
private _memorypoint = "";
private _selection = "";

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
            case ("selection"): {
                _selection = _x;
            };
            case ("memorypoint"): {
                _memorypoint = _x;
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
    nil
} count _dynamicArguments;

GVAR(currentActionID) = GVAR(currentActionID) + 1;
// Convert Condition to String
_condition = _condition call CFUNC(codeToString);
private _format = [
    "[_this, _target, %1] call %2 && {_this call {%3}}",
    "[_this, _target, %1] call %2 && {[_target, %4] call %5} && {_this call {%3}}"
] select (_distance > 0 && !(_target isEqualTo CLib_Player));
_condition = format [_format, _ignoredCanInteractConditions, QCFUNC(canInteractWith), _condition, _distance, QCFUNC(inRange)];

_callback = _callback call CFUNC(codeToString);
_callback = compile (format ["[{%1}, _this] call %2;", _callback, QCFUNC(directCall)]);
if (_text isEqualType "") then {_text = compile ("format [""" + _text + """]")};
if (_target isEqualType "") then {_target = [_target]};

if (_target isEqualType []) then {
    {
        GVAR(Interaction_Actions) pushBackUnique [_x, _text, _condition, _callback, _args, _priority, _showWindow, _hideOnUse, _shortcut, _radius, _unconscious, _selection, _memorypoint, _onActionAdded, GVAR(currentActionID)];
        false
    } count _target;
};

if (_target isEqualType objNull) then {
    if (_target isEqualTo CLib_Player) then {
        if (_text isEqualType {}) then {
            _text = call _text;
        };
        if (_text call CFUNC(isLocalised)) then {
            _text = _text call CFUNC(readLocalisation);
        };
        private _argArray = [_text, _callback, _args, _priority, _showWindow, _hideOnUse, _shortcut, _condition, _radius, _unconscious, _selection, _memorypoint];
        private _id = _target addAction _argArray;
        [_id, _target, _argArray] call _onActionAdded;
        GVAR(PlayerInteraction_Actions) pushBackUnique [_id, _text, _condition, _callback, _args, _priority, _showWindow, _hideOnUse, _shortcut, _radius, _unconscious, _selection, _memorypoint, _onActionAdded, GVAR(currentActionID)];
    } else {
        GVAR(Interaction_Actions) pushBackUnique [_target, _text, _condition, _callback, _args, _priority, _showWindow, _hideOnUse, _shortcut, _radius, _unconscious, _selection, _memorypoint, _onActionAdded, GVAR(currentActionID)];
    };
    DUMP("addAction to " + str _target)
};
