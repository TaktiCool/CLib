#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Remove a Perframe Eventhandler per ID

    Parameter(s):
    0: Index of PFH <Number>

    Returns:
    None
*/
params [["_handle", -1, [0]]];

if (_handle < 0 || {_handle >= count GVAR(PFHhandles)}) exitWith {};

GVAR(perFrameHandlerArray) deleteAt (GVAR(PFHhandles) select _handle);
GVAR(PFHhandles) set [_handle, nil];

{
    _x params ["", "", "", "", "", "_handle"];
    GVAR(PFHhandles) set [_handle, _forEachIndex];
} forEach GVAR(perFrameHandlerArray);
