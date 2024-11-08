#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Dump all CLib relevant varibles to config

    Parameter(s):
    0: Object to dump <Object> (Default: objNull)
    1: Target who receives the dump <Number, Object, String, Side, Group, Array> (Default: objNull)

    Returns:
    None
*/

params [
    ["_unit", objNull, [objNull]],
    ["_returnTo", objNull, [0, objNull, "", sideUnknown, grpNull, []], []]
];

if (!isServer) then {
    if (isNull _returnTo) then {
        _returnTo = CLib_Player;
    };
    if (isNull _unit) then {
        _unit = CLib_Player;
    };
};

if !(local _unit) exitWith {
    [QGVAR(dumpPerformanceInfo), _unit, _this] call CFUNC(targetEvent);
};

private _fnc_outputText = {
    [QGVAR(dump), _returnTo, _this] call CFUNC(targetEvent);
    [QCGVAR(serverLog), [_this, name _unit]] call CFUNC(serverEvent);
};

private _text = format [
    "------CLib Debug------
time = %1
ServerTime =%2
------Performance------
diag_fps = %3
count CLib_waitArray = %4
count CLib_waitUntilArray = %5
count PerframeHandler = %6 (AllTime %7)
count diag_activeSQFScripts = %8
count diag_activeSQSScripts = %9
count diag_activeMissionFSMs = %10",
    time,
    serverTime,
    diag_fps,
    count EGVAR(Perframe,waitArray),
    count EGVAR(Perframe,waitUntilArray),
    count EGVAR(Perframe,perFrameHandlerArray),
    count EGVAR(Perframe,PFHhandles),
    count diag_activeSQFScripts,
    count diag_activeSQSScripts,
    count diag_activeMissionFSMs
];
_text call _fnc_outputText;

if (_unit != CLib_Player) then {
    _text = format [
        "------Unit------
typeOf = %1
animationState = %2
name = %3",
        if (isNull _unit) then {"null"} else {typeOf _unit},
        if (isNull _unit) then {"null"} else {animationState _unit},
        if (isNull _unit) then {"null"} else {name _unit}
    ];
    _text call _fnc_outputText;
};

_text = format [
    "------Client------
typeOf = %1
animationState = %2
name = %3",
    if (isNull CLib_Player) then {"null"} else {typeOf CLib_Player},
    if (isNull CLib_Player) then {"null"} else {animationState CLib_Player},
    if (isNull CLib_Player) then {"null"} else {name CLib_Player}
];
_text call _fnc_outputText;

if (GVAR(FPSStorage) isNotEqualTo []) then {
    _text = "------Last Client Frames------
    ";
    {
        _text = _text + _x + " ";
    } forEach GVAR(FPSStorage);
    _text call _fnc_outputText;
};

"
------CLib Variables------" call _fnc_outputText;

private _searchSpaces = [
    missionNamespace,
    parsingNamespace,
    uiNamespace // Dont work in Multiplayer
];
_searchSpaces append GVAR(allCustomNamespaces);

_searchSpaces append allMissionObjects "";

private _temp = [];
{
    private _space = _x;
    private _count = {
        private _var = _space getVariable [_x, {}];
        if !(_var isEqualType {}) then {
            if (_var isEqualType []) then {
                if ((count _var) < 5) then {
                    _text = format ["%1;%2: %3", _space, _x, _var];
                    _temp pushBack _text;
                } else {
                    _text = format ["%1;%2: %3 ... %4", _space, _x, _var select [0, 4], count _var];
                };
            } else {
                _text = format ["%1;%2: %3", _space, _x, _var];
                _temp pushBack _text;
            };
            true
        } else {
            false
        };
    } count (allVariables _space);
    _text = format ["%1 have %2 Varialbe", _space, _count];
    _text call _fnc_outputText;
} forEach _searchSpaces;

{
    _x call _fnc_outputText;
} forEach _temp;
