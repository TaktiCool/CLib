#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: BadGuy

    Description:
    Draws a notification to a display

    Parameter(s):
    0: Header text <String>
    1: Description text <String>
    2: Icon stack <Array of <Icon>>
    3: Display <Display> (Default: 46)
    4: Position <Number> (0,1,2...)

    Returns:
    0: Control group <Control>
*/
params [["_header", ""],
    ["_description", ""],
    ["_icons", []],
    ["_display", displayNull],
    ["_position",0],
    ["_offset", [0,0]]];

if (isNull _display) exitWith {
    controlNull;
};

private _smallTextSize = PY(2.6) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
private _largeTextSize = PY(3) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
private _formatString = "<t align='center' size='%1' font='RobotoCondensedBold'>%2</t><br/><t align='center' size='%3' font='RobotoCondensed'>%4</t>";

private _grp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
_grp ctrlSetPosition [safeZoneX+ safeZoneW/4 + (_offset select 0), safeZoneY + safeZoneH/6 + (_offset select 1), safeZoneW/2, 0];
_grp ctrlSetFade 1;
_grp ctrlCommit 0;
private _textField = _display ctrlCreate ["RscStructuredText", -1, _grp];
_textField ctrlSetStructuredText parseText format [_formatString, _largeTextSize, toUpper _header, _smallTextSize, _description];
_textField ctrlSetPosition [0, PY(7), safeZoneW/2, PY(10)];
_textField ctrlCommit 0;

{
    _x params ["_path", ["_size", 1], ["_color",[1,1,1,1]], ["_shadow",0]];

    private _icon = _display ctrlCreate ["RscStructuredText", -1, _grp];
    _icon ctrlSetStructuredText parseText format ["<t shadow='%1'><img align='center' size='%2' image='%3'></t>", _shadow, _size*PY(5) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1), _path];
    _icon ctrlSetPosition [0, PY(3) - _size * PY(5/2), safeZoneW/2, PY(10)];
    _icon ctrlSetTextColor _color;
    _icon ctrlCommit 0;
} forEach _icons;
_grp ctrlSetFade 0;
_grp ctrlSetPosition [safeZoneX+ safeZoneW/4 + (_offset select 0), safeZoneY + safeZoneH/6 + (_offset select 1), safeZoneW/2,  PY(20)];
_grp ctrlCommit 0.2;

_grp
