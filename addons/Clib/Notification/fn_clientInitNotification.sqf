#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: joko // Jonas

    Description:
    Init for Notifications

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(NotificationQueue) = [];
GVAR(LastNotification) = -1;
GVAR(NextNotification) = -1;

["displayNotification", {
    (_this select 0) call CFUNC(displayNotification)
}] call FUNC(addEventhandler);
