#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: BadGuy

    Description:
    Registers a display to the notification framework

    Parameter(s):
    0: display <Display>
    1: offset <Array>

    Returns:
    -
*/
params [["_display", displayNull], ["_offset", [0,0]], ["_offsetHint", [0,0]]];

private _idx = GVAR(NotificationDisplays) pushBackUnique [_display, _offset, _offsetHint];

private _deleted = false;
{
    params ["_display"];
    if (isNull _display) then {
        _deleted = true;
        GVAR(NotificationDisplays) set [_forEachIndex, objNull];
    };
} forEach GVAR(NotificationDisplays);

if (_deleted) then {
    GVAR(NotificationDisplays) = GVAR(NotificationDisplays) - [objNull];
};

if (_idx < 0) exitWith {};

private _numberOfNotifications = count GVAR(AllNotifications);

{
     _x params ["_parameter", "_controlGroups"];
     _parameter params [["_header", "Error No Notification Text", ["", []]], ["_description", "Error No Notification Text", ["", []]], ["_icons", []]];
     private _ctrlGrp = [_header, _description, _icons, _display, (_numberOfNotifications-1) - _forEachIndex, _offset] call FUNC(drawNotification);
     _ctrlGrp ctrlSetFade 0;
     _ctrlGrp ctrlCommit 0;
     _controlGroups pushBack [_ctrlGrp, ctrlPosition _ctrlGrp];
} forEach GVAR(AllNotifications);
