#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Code that Runs on everyframe and Dispatches Callbacks for Perframe, SkipFrames, ExecNextFrame, Wait, and WaitUntil

    Parameter(s):
    None

    Returns:
    None
*/

if (getClientState == "GAME FINISHED") exitWith {
    removeMissionEventHandler ["EachFrame", GVAR(OnEachFrameID)];
};

RUNTIMESTART;

// Delta time Describe the time that the last Frame needed to calculate this is required for some One Each Frame Balance Math Calculations
CGVAR(deltaTime) = diag_deltaTime max 0.000001;
GVAR(lastFrameTime) = time;

{
    _x params ["_function", "_delay", "_delta", "_args", "_handle"];

    if (time > _delta) then {
        _x set [2, _delta + _delay];
        if (_function isEqualType "") then {
            _function = (parsingNamespace getVariable [_function, {}]);
        };
        [_args, _handle] call _function;
    };
} forEach GVAR(perFrameHandlerArray);

if (GVAR(sortWaitArray)) then {
    GVAR(waitArray) sort true;
    GVAR(sortWaitArray) = false;
};

private _delete = false;

{
    if (_x select 0 > time) exitWith {};
    (_x select 2) call (_x select 1);
    _delete = true;
    GVAR(waitArray) set [_forEachIndex, objNull];
} forEach GVAR(waitArray);

if (_delete) then {
    GVAR(waitArray) = GVAR(waitArray) - [objNull];
    _delete = false;
};

{
    if (_x isEqualType [] && {(_x select 2) call (_x select 1)}) then {
        (_x select 2) call (_x select 0);
        _delete = true;
        GVAR(waitUntilArray) set [_forEachIndex, objNull];
    };
} forEach GVAR(waitUntilArray);

if (_delete) then {
    GVAR(waitUntilArray) = GVAR(waitUntilArray) - [objNull];
    _delete = false;
};

if (GVAR(sortSkipFrameArray)) then {
    GVAR(skipFrameArray) sort true;
    GVAR(sortSkipFrameArray) = false;
};

{
    if (_x select 0 >= diag_frameNo) exitWith {};
    (_x select 2) call (_x select 1);
    _delete = true;
    GVAR(skipFrameArray) set [_forEachIndex, objNull];
    nil
} forEach GVAR(skipFrameArray);

if (_delete) then {
    GVAR(skipFrameArray) = GVAR(skipFrameArray) - [objNull];
    _delete = false;
};

//Handle the execNextFrame array:
{
    (_x select 0) call (_x select 1);
} forEach GVAR(currentFrameBuffer);

//Swap double-buffer:
GVAR(currentFrameBuffer) = GVAR(nextFrameBuffer);
GVAR(nextFrameBuffer) = [];
GVAR(nextFrameNo) = diag_frameNo + 1;

RUNTIME("PFHCounter");
