#include "macros.hpp"
#include "\a3\ui_f\hpp\defineCommonGrids.inc"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: Karel Moricky
    a3/functions_f/GUI/fn_textTi.sqf

    Description:
    Show animated text

    Parameter(s):
    0: Content <String, Text> (Default: "#(argb,8,8,3)color(1,0,1,1)")
    1: Position <Array, Bool> (Default: [0, 0, 1, 1])
    2: Size <Number, Array> (Default: 10)
    3: Duration <Number> (Default: 5)
    4: Fade Times <Array, Number> (Default: [0.5, 0.5])
    5: Max Alpha <Number> (Default: 0.3)
    6: On Fade out <Code> (Default: {})

    Returns:
    None
*/

params [
    ["_content", "#(argb,8,8,3)color(1,0,1,1)", ["", text ""]],
    ["_pos", [0, 0, 1, 1], [[], true], 4],
    ["_size", 10, [0, []], 2],
    ["_duration", 5, [0]],
    ["_fade", [0.5, 0.5], [[], 0], 2],
    ["_maxAlpha", 0.3, [0]],
    ["_onFadeOut", {}, [{}]]
];

private _fadeIn = _fade param [0, 0.5, [0]];
private _fadeOut = _fade param [1, _fadeIn, [0]];

if (_size isEqualType 0) then {_size = [_size, _size]};

if (_pos isEqualType true) then {
    if (_pos) then {
        _pos = [
            (IGUI_GRID_MISSION_X) call BIS_fnc_parseNumber,
            (IGUI_GRID_MISSION_Y) call BIS_fnc_parseNumber,
            (IGUI_GRID_MISSION_WAbs) call BIS_fnc_parseNumber,
            (IGUI_GRID_MISSION_HAbs) call BIS_fnc_parseNumber
        ];
        _size = [
            IGUI_GRID_MISSION_WAbs / IGUI_GRID_MISSION_W / 2,
            IGUI_GRID_MISSION_HAbs / IGUI_GRID_MISSION_H
        ];
    } else {
        _pos = [safezoneX, safezoneY, safezoneW, safezoneH];
    };
};

_pos params ["_posX", "_posY", "_posW", "_posH"];

_size params ["_sizeX", "_sizeY"];
private _sizeW = _posW / _sizeX;
private _sizeH = _posH / _sizeY;

("bis_fnc_textTiles" call BIS_fnc_rscLayer) cutRsc ["RscTilesGroup", "plain"];
private _display = uiNamespace getVariable "RscTilesGroup";

private _xList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
private _yList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
_xList resize _sizeX;
_yList resize _sizeY;
private _grids = [];
for "_x" from 0 to (_sizeX - 1) do {
    for "_y" from 0 to (_sizeY - 1) do {
        _grids pushBack [_x, _y];
    };
};

private _contentIsStructuredText = _content isEqualType (parseText "");

{
    _x params ["_ix", "_iy"];

    //--- Group
    private _group = _display displayCtrl (1000 + _ix * 10 + _iy);
    _group ctrlSetPosition [
        _posX + _ix * _sizeW,
        _posY + _iy * _sizeH,
        _sizeW,
        _sizeH
    ];
    _group ctrlCommit 0;

    //--- Content
    private _groupContent = if (_contentIsStructuredText) then {
        private _temp = _display displayCtrl (1100 + _ix * 10 + _iy);
        _temp ctrlSetStructuredText _content;
        _temp
    } else {
        private _temp = _display displayCtrl (1200 + _ix * 10 + _iy);
        _temp ctrlSetText _content;
        _temp
    };
    _groupContent ctrlSetPosition [
        -_ix * _sizeW,
        -_iy * _sizeH - 0.1 + random 0.2,
        _posW,
        _posH
    ];
    private _color = random 0.4;

    private _alpha = if (random 1 > 0.1) then {_maxAlpha} else {_maxAlpha * 0.5};

    _groupContent ctrlSetBackgroundColor [_color, _color, _color, _alpha];
    _groupContent ctrlSetFade 1;
    _groupContent ctrlCommit 0;

    //--- Animate
    _groupContent ctrlSetPosition [
        -_ix * _sizeW,
        -_iy * _sizeH,
        _posW,
        _posH
    ];
    _groupContent ctrlSetFade 0;
    _groupContent ctrlCommit (random _fadeIn);
} forEach _grids;

[{
    params ["_grids", "_contentIsStructuredText", "_sizeW", "_sizeH", "_posW", "_posH", "_fadeOut", "_onFadeOut"];
    private _display = uiNamespace getVariable "RscTilesGroup";
    {
        _x params ["_ix", "_iy"];
        private _groupContent = if (_contentIsStructuredText) then {
            _display displayCtrl (1100 + _ix * 10 + _iy);
        } else {
            _display displayCtrl (1200 + _ix * 10 + _iy);
        };

        _groupContent ctrlSetPosition [
            -_ix * _sizeW,
            -_iy * _sizeH - 0.1 + random 0.2,
            _posW,
            _posH
        ];
        _groupContent ctrlSetFade 1;
        _groupContent ctrlCommit (random _fadeOut);
    } forEach _grids;
    [{
        private _display = uiNamespace getVariable "RscTilesGroup";
        _display closeDisplay 0;
    }, _fadeOut] call CFUNC(wait);
    call _onFadeOut;
}, _fadeIn + _duration, [_grids, _contentIsStructuredText, _sizeW, _sizeH, _posW, _posH, _fadeOut, _onFadeOut]] call CFUNC(wait);
