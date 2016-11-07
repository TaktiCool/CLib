#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    create function that Check if player is Speaking

    Parameter(s):
    None

    Returns:
    None
*/
if (isServer) then {
    addMissionEventHandler ["HandleDisconnect", {
        params ["_player"];
        _player setVariable [QGVAR(isUsingVoice), false, true];
    }];
};

if !(hasInterface) exitWith {};

["playerChanged", {
    (_this select 0) params ["", "_oldUnit"];
    _oldUnit setVariable [QGVAR(isUsingVoice), false, true];
}] call CFUNC(addEventhandler);
private _cfg = configFile >> "CfgPatches";
switch (true) do {
    case (isClass (_cfg >> "acre_api")): {
        LOG("ACRE Detected.")
        DCFUNC(isSpeaking) = {
            [_unit] call acre_api_fnc_isSpeaking;
        };
    };
    case (isClass (_cfg >> "task_force_radio")): {
        LOG("TFAR Detected.")
        DCFUNC(isSpeaking) = {
            _unit getVariable ["tf_isSpeaking", false];
        };
    };
    default {
        LOG("No VON Mod Detected")
        [{
            private _new = (!(isNull findDisplay 55));
            if !((CLib_player getVariable [QGVAR(isUsingVoice), false]) isEqualTo _new) then {
                CLib_player setVariable [QGVAR(isUsingVoice), _new, true];
            };
        }, 0.2] call CFUNC(addPerFrameHandler);

        DCFUNC(isSpeaking) ={
            params ["_unit"];
            (_unit getVariable [QGVAR(isUsingVoice), false])
        };
    };
};
