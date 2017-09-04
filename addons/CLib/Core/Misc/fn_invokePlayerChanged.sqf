#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Invokes Scripted player Change

    Parameter(s):
    new Player

    Returns:
    None
*/
params ["_newPlayer"];

["playerChanged", [_newPlayer, CLib_Player]] call CFUNC(localEvent);
EGVAR(Events,EventNamespace) setVariable [QGVAR(Events,EventData_player), _newPlayer];
