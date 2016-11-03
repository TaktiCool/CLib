#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Callback function for the Hold Action

    Parameter(s):
    0: Argument <Type>

    Returns:
    0: Return <Type>
*/

params ["_target", "_caller", "_id", "_actionArguments"];
_actionArguments params
[
    "_title",
    "_hint",
    "_iconIdle",
    "_iconProgress",
    "_condShow",
    "_condProgress",
    "_codeStart",
    "_codeProgress",
    "_codeCompleted",
    "_codeInterrupted",
    "_arguments",
    "_priority",
    "_removeCompleted",
    "_showUnconscious",
    "_ignoredCanInteractConditions"
];

GVAR(DisablePrevAction) = true;
GVAR(DisableNextAction) = true;
GVAR(HoldActionStartTime) = diag_tickTime;

[_target, _caller, _id, _arguments] call _codeStart;


if (isNull (uiNamespace getVariable [UIVAR(HoldAction),displayNull])) then {
    private _display = findDisplay 46;
    private _ctrl = _display ctrlCreate ["RscStructuredText", 6000];
    _ctrl ctrlSetPosition [0, 0.509, 1, 0.5];
    _ctrl ctrlSetFont "PuristaMedium";

    _ctrl = _display ctrlCreate ["RscStructuredText", 6001];
    _ctrl ctrlSetPosition [0, 0.509, 1, 0.5];
    _ctrl ctrlSetFont "PuristaMedium";
    uiNamespace setVariable [UIVAR(HoldAction), _display];
    //([UIVAR(HoldAction)] call BIS_fnc_rscLayer) cutRsc [UIVAR(HoldAction),"PLAIN",0];
};



[{
    params ["_args", "_handle"];
    _args params ["_target", "_caller", "_id", "_actionArguments"];
    _actionArguments params
    [
        "_title",
        "_hint",
        "_iconIdle",
        "_iconProgress",
        "_condShow",
        "_condProgress",
        "_codeStart",
        "_codeProgress",
        "_codeCompleted",
        "_codeInterrupted",
        "_arguments",
        "_priority",
        "_removeCompleted",
        "_showUnconscious"
    ];
    private _ret = !((inputAction "Action" < 0.5 && {inputAction "ActionContext" < 0.5}) || !(call _condProgress));
    private _display = uiNamespace getVariable [UIVAR(HoldAction),displayNull];

    if (_ret) then {
        _ret = [_target, _caller, _id, _arguments] call _codeProgress;
    };

    if (_ret isEqualType 0) then {
        _ret = (_ret min 1) max 0;
        private _progressIconPath = format ["\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_%1_ca.paa", floor (_ret*24)];
        if (diag_tickTime - GVAR(HoldActionStartTime) <= 0.15) then {
            _progressIconPath = format ["\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_%1_ca.paa", floor ((diag_tickTime - GVAR(HoldActionStartTime)) / 0.05)];
        };

        if (_id isEqualType 123) then {

            (_display displayCtrl 6000) ctrlSetPosition [0, 0.54, 1, 0.5];
            (_display displayCtrl 6001) ctrlSetPosition [0, 0.54, 1, 0.5];
            (_display displayCtrl 6000) ctrlSetStructuredText parseText format ["<t align='center'><img size='3' shadow='0' color='#ffffffff' image='%1'/></t>", _progressIconPath];
            (_display displayCtrl 6001) ctrlSetStructuredText parseText format ["<t align='center'><img size='3' shadow='0' color='#ffffffff' image='%1'/></t>", call _iconProgress];
            (_display displayCtrl 6000) ctrlCommit 0;
            (_display displayCtrl 6001) ctrlCommit 0;
            _target setUserActionText [_id,_title,"",""];
        } else {
            (_display displayCtrl 6000) ctrlSetPosition [0, 0.509, 1, 0.5];
            (_display displayCtrl 6001) ctrlSetPosition [0, 0.509, 1, 0.5];
            (_display displayCtrl 6000) ctrlSetStructuredText parseText format ["<t align='center'><img size='3.5' shadow='0' color='#ffffffff' image='%1'/></t>", _progressIconPath];
            (_display displayCtrl 6001) ctrlSetStructuredText parseText format ["<t align='center'><img size='3.5' shadow='0' color='#ffffffff' image='%1'/></t>", call _iconProgress];
            (_display displayCtrl 6000) ctrlCommit 0;
            (_display displayCtrl 6001) ctrlCommit 0;
        };



        if (_ret >= 1) then {
            _ret = true;
        };
    };

    if (_ret isEqualType true) then {
        if (_ret) then {
            _args call _codeCompleted;
        } else {
            _args call _codeInterrupted;
        };

        GVAR(DisablePrevAction) = false;
        GVAR(DisableNextAction) = false;
        GVAR(HoldActionStartTime) = -1;

        (_display displayCtrl 6001) ctrlSetStructuredText parseText "";
        (_display displayCtrl 6000) ctrlSetStructuredText parseText "";
        (_display displayCtrl 6000) ctrlCommit 0;
        (_display displayCtrl 6001) ctrlCommit 0;

        if (_id isEqualType 123) then {
            _target setUserActionText [_id,_title, "<img size='3' shadow='0' color='#ffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_0_ca.paa'/><br/><br/>" + _hint, format ["<img size='3' shadow='0' color='#ffffffff' image='%1'/>", (call _iconProgress)]];
        };
        _handle call CFUNC(removePerFrameHandler);
    };
}, 0, _this] call CFUNC(addPerFrameHandler);
