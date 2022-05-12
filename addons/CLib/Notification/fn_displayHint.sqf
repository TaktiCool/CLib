#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy, joko // Jonas

    Description:
    Displays a Notification

    Parameter(s):
    0: Header text <Array, String>
    1: Description text <String, Array>
    2: Icon stack <Array of <Icon>>

    Returns:
    None

    Remarks:
    <Icon>
        0: icon path <String>
        1: size <Number>
        2: color <Array>
*/

params [
    ["_header", "", ["", []]],
    ["_description", "", ["", []]],
    ["_icons", [], [[]]],
    ["_playSound", false, [false, [], ""]]
];

{
    if (!isNull _x) then {
        _x ctrlSetFade 1;
        _x ctrlCommit 0.3;
    };
} forEach GVAR(CurrentHint);
[{
    {
        if (!isNull _x) then {
            ctrlDelete _x;
        };
    } forEach _this;
}, 0.5, GVAR(CurrentHint)] call CFUNC(wait);

private _controlGroups = [];
GVAR(CurrentHint) = [];

if (_playSound isEqualType true && {_playSound}) then {
    playSound "Hint";
} else {
    if (_playSound isEqualType [] || _playSound isEqualType "") then {
        playSound _playSound;
    };
};
private _deleted = false;

{
    _x params ["_display", "_offset", "_offsetHint"];
    if (!isNull _display) then {
        private _ctrlGrp = [_header, _description, _icons, _display, 0, _offsetHint] call FUNC(drawHint);
        GVAR(CurrentHint) pushBack _ctrlGrp;
    } else {
        _deleted = true;
        GVAR(NotificationDisplays) set [_forEachIndex, objNull];
    };
} forEach GVAR(NotificationDisplays);

if (_deleted) then {
    GVAR(NotificationDisplays) = GVAR(NotificationDisplays) - [objNull];
};

[{
    {
        if (!isNull _x) then {
            _x ctrlSetFade 1;
            _x ctrlCommit 0.3;
        };
    } forEach _this;
    [{
        {
            if (!isNull _x) then {
                ctrlDelete _x;
            };
        } forEach _this;
        if (_this isEqualTo GVAR(CurrentHint)) then {
            GVAR(CurrentHint) = [];
        };
    }, 0.5, _this] call CFUNC(wait);
}, 6, GVAR(CurrentHint)] call CFUNC(wait);
