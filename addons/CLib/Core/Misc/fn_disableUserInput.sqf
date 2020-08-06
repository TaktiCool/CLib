#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: commy2
    https://github.com/acemod/ACE3/blob/3d5ea74c7ec44dde291765f632df0004cfe101a9/addons/common/functions/fnc_disableUserInput.sqf

    Description:
    Disables key input. ESC can still be pressed to open the menu.

    Parameter(s):
    0: Disable user input <Bool> (Default: true)

    Returns:
    None
*/

if (!hasInterface) exitWith {};

EXEC_ONLY_UNSCHEDULED;

params [
    ["_state", true, [true]]
];

if (_state) then {
    if (!isNil QGVAR(disableUserInputKeyEventHandler)) exitWith {};

    // Close map
    if (visibleMap) then {
        openMap false;
    };
    GVAR(DisablePrevAction) = true;
    GVAR(DisableNextAction) = true;
    GVAR(DisableAction) = true;

    GVAR(disableUserInputScrollWheelEventHandler) = (findDisplay 46) displayAddEventHandler ["MouseZChanged", {true}];
    GVAR(disableUserInputMouseButtonEventHandler) = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", {true}];
    GVAR(disableUserInputKeyEventHandler) = (findDisplay 46) displayAddEventHandler ["KeyDown", {
        params ["", "_key"];

        if (_key == 1) then {
            createDialog (["RscDisplayInterrupt", "RscDisplayMPInterrupt"] select isMultiplayer);

            private _dlg = findDisplay 49;

            for "_index" from 100 to 2000 do {
                (_dlg displayCtrl _index) ctrlEnable false;
            };

            private _ctrl = _dlg displayctrl 103;
            _ctrl ctrlSetEventHandler ["buttonClick", call FUNC(onButtonClickEndStr)];
            _ctrl ctrlEnable true;
            _ctrl ctrlSetText "ABORT";
            _ctrl ctrlSetTooltip "Abort.";

            _ctrl = _dlg displayctrl ([104, 1010] select isMultiplayer);
            _ctrl ctrlSetEventHandler ["buttonClick", call FUNC(onButtonClickRespawnStr)];
            _ctrl ctrlEnable call {
                private _config = missionConfigFile >> "respawnButton";
                !isNumber _config || {getNumber _config == 1}
            };
            _ctrl ctrlSetText "RESPAWN";
            _ctrl ctrlSetTooltip "Respawn.";
        };

        if (_key in actionKeys "CuratorInterface" && {getAssignedCuratorLogic player in allCurators}) exitWith {
            //openCuratorInterface;
            false
        };

        if (_key in (actionKeys "ShowMap" + actionKeys "PushToTalk" + actionKeys "PushToTalkAll" + actionKeys "PushToTalkCommand" + actionKeys "PushToTalkDirect" + actionKeys "PushToTalkGroup" + actionKeys "PushToTalkSide" + actionKeys "PushToTalkVehicle")) exitWith {
            false;
        };

        if (isServer || {serverCommandAvailable "#kick"} || {player getVariable [QEGVAR(Revive,isUnconscious), false]}) then {
            if (!(_key in (actionKeys "DefaultAction" + actionKeys "Throw")) && {_key in (actionKeys "Chat" + actionKeys "PrevChannel" + actionKeys "NextChannel")}) exitWith {
                false;
            };
        };

        true
    }];
} else {
    if !(isNil QGVAR(disableUserInputKeyEventHandler)) then {
        (findDisplay 46) displayRemoveEventHandler ["KeyDown", GVAR(disableUserInputKeyEventHandler)];
        (findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", GVAR(disableUserInputMouseButtonEventHandler)];
        (findDisplay 46) displayRemoveEventHandler ["MouseZChanged", GVAR(disableUserInputScrollWheelEventHandler)];
    };
    GVAR(disableUserInputKeyEventHandler) = nil;
    GVAR(disableUserInputMouseButtonEventHandler) = nil;
    GVAR(disableUserInputScrollWheelEventHandler) = nil;
    GVAR(DisablePrevAction) = false;
    GVAR(DisableNextAction) = false;
    GVAR(DisableAction) = false;
};
