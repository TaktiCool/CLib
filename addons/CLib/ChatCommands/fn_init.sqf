#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:


    Parameter(s):


    Returns:
    None
*/
GVAR(chatCommands) = createHashMap;

GVAR(chatCommandPrefix) = "!";
private _config = (missionConfigFile >> QPREFIX >> "chatCommandPrefix");
if (isText _config) then {
    GVAR(chatCommandPrefix) = getText _config;
};

GVAR(chatChannels) = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

DFUNC(onChatMessage) = {
    params ["_channel", "", "", "_text", "_person"];
    private _index = _text find " ";
    if (_index == -1) then {
        _index = count _text;
    };

    private _command = _text select [1, _index - 1];
    diag_log ("Command: " + _command);
    // check if command is available
    if !(_command in GVAR(chatCommands)) exitWith {false};
    if !(local _person) exitWith {true}; // dont show commands on other clients


    private _arguments = (_text select [_index + 1]) splitString " ";
    private _commandData = GVAR(chatCommands) get _command;
    private _access = ["all", getPlayerUID _person];

    if (IS_ADMIN || isServer) then {
        _access pushBack "admin";
    };

    if (IS_ADMIN_LOGGED || isServer) then {
        _access pushBack "adminlogged";
    };
    _commandData params ["_callback", "_availableFor", "_args", "_channels"];
    if !(_channel in _channels) exitWith {};
    if (_availableFor findIf { _x in _access } == -1) exitWith {};
    [_arguments, _args, _this] call _callback;
};

addMissionEventHandler ["HandleChatMessage", {
    if (((_this select 3) select [0, 1]) isEqualTo GVAR(chatCommandPrefix)) then {
        _this call FUNC(onChatMessage);
    };
}];
