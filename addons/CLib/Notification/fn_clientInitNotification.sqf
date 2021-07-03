#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    Init for Notifications

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(AllNotifications) = [];
GVAR(NotificationDisplays) = [];
GVAR(CurrentHint) = [];

["displayNotification", {
    (_this select 0) call CFUNC(displayNotification);
}] call CFUNC(addEventhandler);

["displayHint", {
    (_this select 0) call CFUNC(displayHint);
}] call CFUNC(addEventhandler);

["missionStarted", {
    [findDisplay 46] call CFUNC(registerDisplayNotification)
}] call CFUNC(addEventhandler);
