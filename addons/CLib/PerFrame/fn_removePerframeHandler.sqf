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

EXEC_ONLY_UNSCHEDULED

params [["_handle", -1, [0]]];

if (_handle < 0 || {_handle >= count GVAR(PFHhandles)}) exitWith {};
private _index = GVAR(PFHhandles) select _handle;

if (isNil "_index") exitWith {};
GVAR(deletedIndices) pushback _index;

private _oldData = GVAR(perFrameHandlerArray) select _index;
_oldData set [5, true];

GVAR(perFrameHandlerArray) set [_index, _oldData];

GVAR(PFHhandles) set [_handle, nil];
