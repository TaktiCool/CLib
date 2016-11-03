#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Get Logic Group and create if it not exist

    Parameter(s):
    None

    Returns:
    Logic Gruppe <Group>
*/

private _grp = missionNamespace getVariable QGVAR(logicGroup);
if (isNil "_grp") then {
    _grp = createGroup (createCenter sideLogic);
    missionNamespace setVariable [QGVAR(logicGroup),_grp,true];
};

_grp;
