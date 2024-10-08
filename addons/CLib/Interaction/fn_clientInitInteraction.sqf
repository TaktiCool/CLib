#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init for Interaction

    Parameter(s):
    None

    Returns:
    None
*/

if !(hasInterface) exitWith {};

GVAR(currentActionID) = -1;
GVAR(Interaction_Actions) = [];
GVAR(PlayerInteraction_Actions) = [];
["cursorObjectChanged", {(_this select 0) call FUNC(onCursorObjectChanged)}] call CFUNC(addEventhandler);
["playerChanged", {
    (_this select 0) params ["_currentPlayer", "_oldPlayer"];
    // Posible Fix for Double Squad Menu Entry
    if (_currentPlayer isEqualTo _oldPlayer) exitWith {};
    {
        _x params ["_id", "_text", "_condition", "_callback", "_args", "_priority", "_showWindow", "_hideOnUse", "_shortcut", "_radius", "_unconscious", "_selection", "_memorypoint", "_onActionAdded"];
        _oldPlayer removeAction _id;
        private _argArray = [_text, _callback, _args, _priority, _showWindow, _hideOnUse, _shortcut, _condition, _radius, _unconscious, _selection, _memorypoint];
        _id = _currentPlayer addAction _argArray;
        [_id, _currentPlayer, _argArray] call _onActionAdded;
        _x set [0, _id];
        DUMP("add Real Action to Object Player " + str _text);
    } forEach GVAR(PlayerInteraction_Actions);
}] call CFUNC(addEventhandler);

// fix issue that Action dont get readded after setRespawnTime respawn, because Variables get copyed from the old Unit via Engine command
["MPRespawn", {
    (_this select 0) params ["_newUnit"];
    _newUnit setVariable [QGVAR(ActionIDs), []];
}] call CFUNC(addEventhandler);

GVAR(InGameUIEventHandler) = createHashMap;
GVAR(DisablePrevAction) = false;
GVAR(DisableNextAction) = false;
GVAR(DisableAction) = false;

private _inGameUiEventHandler = {
    params ["_target", "_caller", "_idx", "_id", "_title", "_priority", "_showWindow", "_hideOnUse", "_shortcut", "_visibility", "_eventName"];

    if (GVAR(DisablePrevAction) && {_eventName == "PrevAction"} || (GVAR(DisableNextAction) && {_eventName == "NextAction"}) || (GVAR(DisableAction) && {_eventName == "Action"})) then {
        true
    } else {
        private _ehData = GVAR(InGameUIEventHandler) getOrDefault [toLowerANSI (format ["%1_%2", _eventName, _id]), []];
        _ehData params [["_code", {}], ["_args", []]];
        [_target, _caller, _id, _args] call _code;
    };
};

inGameUISetEventHandler ["PrevAction", _inGameUiEventHandler call CFUNC(codeToString)];
inGameUISetEventHandler ["NextAction", _inGameUiEventHandler call CFUNC(codeToString)];
inGameUISetEventHandler ["Action", _inGameUiEventHandler call CFUNC(codeToString)];

GVAR(HoldActionIdleBackground) = [];
for "_i" from 0 to 11 do {
    private _alpha = (sin ((_i / 11) * 360) * 0.25) + 0.75;
    private _color = [1, 1, 1, _alpha] call BIS_fnc_colorRGBAtoHTML;

    GVAR(HoldActionIdleBackground) pushBack (format ["<img size='3' shadow='0' color='%1' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_0_ca.paa'/>", _color]);
};

DFUNC(IdleAnimation) = [{
    if (GVAR(HoldActionStartTime) >= 0) exitWith {};
    params ["_title", "_keyName", "_iconIdle"];
    _target setUserActionText [
        _actionID,
        format ["<t color='#FFFFFF' align='left'>%1</t>        <t color='#83ffffff' align='right'>%2     </t>", _title, _keyName],
        GVAR(HoldActionIdleBackground) select floor ((time / 0.065) % 12),
        format ["<img size='3' shadow='0' color='#ffffff' image='%1'/><br/><br/><t font='RobotoCondensedBold'>%2</t>", call _iconIdle, format [localize "STR_A3_HoldKeyTo", format ["<t color='#ffae00'>%1</t>", _keyName], _title]]
    ];
}] call CFUNC(compileFinal);
