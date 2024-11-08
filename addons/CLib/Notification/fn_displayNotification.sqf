#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy, joko // Jonas

    Description:
    Displays a Notification

    Parameter(s):
    0: Header text <String, Array>
    1: Description text <String, Array>
    2: Icon stack <Array of <Icon>>
    3. Play Sound <Boolean, String, Array>

    Returns:
    None

    Remarks:
    <Icon>
        0: icon path <String>
        1: size <Number>
        2: color <Array>
*/

params [
    ["_header", "Error No Notification Text", ["", []]],
    ["_description", "Error No Notification Text", ["", []]],
    ["_icons", []],
    ["_playSound", false, [false, [], ""]]
];

private _controlGroups = [];
private _deleted = false;

if (_header isEqualType []) then {
    _header = _header call CFUNC(formatLocalization);
};

if (_description isEqualType []) then {
    _description = _description call CFUNC(formatLocalization);
};

{
    _x params ["_display", "_offset"];
    if (!isNull _display) then {
        private _ctrlGrp = [_header, _description, _icons, _display, 0, _offset] call FUNC(drawNotification);
        private _pos = ctrlPosition _ctrlGrp;
        private _oldPos = +_pos;
        _pos set [1, (_pos select 1) + (_pos select 3)];
        _pos set [3, 0];
        _ctrlGrp ctrlSetPosition _pos;
        _ctrlGrp ctrlCommit 0;
        _ctrlGrp ctrlSetPosition _oldPos;
        _ctrlGrp ctrlSetFade 0;
        _ctrlGrp ctrlCommit 0.3;
        _controlGroups pushBack [_ctrlGrp, _oldPos];
    } else {
        _deleted = true;
        GVAR(NotificationDisplays) set [_forEachIndex, objNull];
    };
} forEach GVAR(NotificationDisplays);

if (_deleted) then {
    GVAR(NotificationDisplays) = GVAR(NotificationDisplays) - [objNull];
};

{
    _x params ["_parameter", "_groups"];
    {
        _x params ["_group", "_committedPosition"];
        if (!isNull _group) then {
            _committedPosition set [1, (_committedPosition select 1) - (_committedPosition select 3)];
            _group ctrlSetPosition _committedPosition;
            _group ctrlCommit 0.3;
        };
    } forEach _groups;
} forEach GVAR(AllNotifications);

private _item = [[_header, _description, _icons, _playSound], _controlGroups];

switch (typeName _playSound) do {
    case "BOOL": {
        playSound "HintExpand";    
    };
    case "STRING": {
        playSound _playSound;
    };
    case "ARRAY": {
        _playSound params [["_sound", ""]];
        if (_sound != "") then {
            playSound _sound;
        };
    };
    default { };
};

private _idx = GVAR(AllNotifications) pushBack _item;
[{
    params ["_parameter", "_controlsGroup"];
    _parameter params ["", "", "", "_playSound"];
    {
        _x params ["_group", "_committedPosition"];
        if (!isNull _group) then {
            _group ctrlSetFade 1;
            _group ctrlCommit 0.3;
        };
    } forEach _controlsGroup;

    switch (typeName _playSound) do {
        case "BOOL": {
            playSound "HintCollapse";    
        };
        case "STRING": {
            playSound _playSound;
        };
        case "ARRAY": {
        _playSound params ["", ["_sound", ""]];
        if (_sound != "") then {
            playSound _sound;
        };        };
        default { };
    };

    [{
        params ["_parameter", "_controlsGroup"];
        {
            _x params ["_group", "_committedPosition"];
            if (!isNull _group) then {
                ctrlDelete _group;
            };
        } forEach _controlsGroup;
        GVAR(AllNotifications) = GVAR(AllNotifications) - [_this];
    }, 0.5, _this] call CFUNC(wait);
}, 10, _item] call CFUNC(wait);
