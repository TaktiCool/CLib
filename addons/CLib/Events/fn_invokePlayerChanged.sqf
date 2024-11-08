#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Invokes Scripted player Change

    Parameter(s):
    0: New player <Object> (Default: objNull)

    Returns:
    None
*/

params [
    ["_newPlayer", objNull, [objNull]]
];

["playerChanged", [_newPlayer, CLib_Player]] call CFUNC(localEvent);
GVAR(EventNamespace) set [QGVAR(EventData_player), _newPlayer];
