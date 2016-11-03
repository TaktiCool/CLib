#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Dump all CLib Relevant Varibles to Config

    Parameter(s):
    0: Object or Client owner on what the Dump should get Created <Object, Number>


    TODO
    fix this function in CLib

    Returns:
    None
*/
params ["_unit"];

if !(local _unit) exitWith {
    [_unit] remoteExecCall [_fnc_scriptName, _unit];
};

private ["_var", "_unit", "_fnc_outputText", "_text"];

private _fnc_outputText = {
    if (count (_this select 0) > 1000) exitWith {};
    diag_log text (_this select 0);
    GVAR(sendlogfile) = [(_this select 0), "PERFORMACE_DUMP_" + getPlayerUID CLib_Player];
    publicVariableServer QGVAR(sendlogfile);
};

_text = format [
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
count GVAR(waitArray),
count GVAR(waitUntilArray),
count GVAR(perFrameHandlerArray),
{!(isNil "_x")} count GVAR(PFHhandles),
count diag_activeSQFScripts,
count diag_activeSQSScripts,
count diag_activeMissionFSMs
];
[_text] call _fnc_outputText;


_text = format ["
------Player------
typeOf = %1
animationState = %2",
if (isNull CLib_Player) then {"null"} else {typeOf CLib_Player},
if (isNull CLib_Player) then {"null"} else {animationState CLib_Player}];
[_text] call _fnc_outputText;


_text = format ["
------CLib Variables------"];
[_text] call _fnc_outputText;

private _searchSpaces = [missionNamespace, parsingNamespace, uiNamespace /*dont work in Multiplayer*/];
_searchSpaces append GVAR(allCustomNamespaces);

_searchSpaces append allMissionObjects "";

private _temp = [];
{
    private _space = _x;
    _count = {
        if (_x find QPREFIX != -1) then {
            private _var = _space getVariable _x;
            if !(_var isEqualType {}) then {
                if (_var isEqualType []) then {
                    if ((count _var) < 5) then {
                        _text = format ["%1;%2: %3", _space, _x, _var];
                        _temp pushBack _text;
                    };
                } else {
                    _text = format ["%1;%2: %3", _space, _x, _var];
                    _temp pushBack _text;
                };
                true
            } else {
                false
            };
        } else {
            false
        };
    } count (allVariables _space);
    _text = format ["%1 have %2 Varialbe", _space , _count];
    [_text] call _fnc_outputText;
} count _searchSpaces;
{
    [_x] call _fnc_outputText;
} count _temp;
