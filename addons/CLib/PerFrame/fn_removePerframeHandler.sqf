#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Remove a PerFrame Eventhandler per ID

    Parameter(s):
    0: Index of PFH <Number> (Default: -1)

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_handle", -1, [0]]
];

if (_handle < 0 || {_handle >= count GVAR(PFHhandles)}) exitWith {};
private _index = GVAR(PFHhandles) select _handle;

if (isNil "_index") exitWith {};

private _oldData = GVAR(perFrameHandlerArray) select _index;
_oldData set [0, {}];

GVAR(PFHhandles) set [_handle, nil];
if (GVAR(deletedIndices) isEqualTo []) then {
    [{
        {
            GVAR(perFrameHandlerArray) set [_x, objNull];
        } forEach GVAR(deletedIndices);

        GVAR(perFrameHandlerArray) = GVAR(perFrameHandlerArray) - [objNull];

        {
            _x params ["", "", "", "", "_handle"];
            GVAR(PFHhandles) set [_handle, _forEachIndex];
        } forEach GVAR(perFrameHandlerArray);
        GVAR(deletedIndices) = [];
    }] call CFUNC(execNextFrame);
};
GVAR(deletedIndices) pushback _index;
