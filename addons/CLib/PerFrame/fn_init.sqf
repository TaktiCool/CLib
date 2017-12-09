#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init for PFH

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(waitArray) = [];
GVAR(sortWaitArray) = false;

GVAR(waitUntilArray) = [];

GVAR(perFrameHandlerArray) = [];
GVAR(PFHhandles) = [];
GVAR(pfhDeleleted) = false;
GVAR(deletedIndexes) = [];

GVAR(skipFrameArray) = [];
GVAR(sortSkipFrameArray) = false;

GVAR(nextFrameBufferA) = [];
GVAR(nextFrameBufferB) = [];
GVAR(nextFrameNo) = diag_frameNo;

CGVAR(deltaTime) = diag_tickTime - (diag_tickTime / 10000);
GVAR(lastFrameTime) = diag_tickTime;

DFUNC(onEachFrameHandler) = {
    if (getClientState == "GAME FINISHED") exitWith {
        removeMissionEventHandler ["EachFrame", GVAR(OnEachFrameID)];
    };

    PERFORMANCECOUNTER_START(PFHCounter);

    // Delta time Describe the time that the last Frame needed to calculate this is required for some One Each Frame Balance Math Calculations
    CGVAR(deltaTime) = diag_tickTime - GVAR(lastFrameTime);
    GVAR(lastFrameTime) = diag_tickTime;

    {
        _x params ["_function", "_delay", "_delta", "_args", "_handle", "_isDeleted"];

        if (time > _delta && !_isDeleted) then {
            _x set [2, _delta + _delay];
            if (_function isEqualType "") then {
                _function = (parsingNamespace getVariable [_function, {}]);
            };
            [_args, _handle] call _function;
        };
        nil
    } count GVAR(perFrameHandlerArray);


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
        nil
    } count GVAR(nextFrameBufferA);

    //Swap double-buffer:
    GVAR(nextFrameBufferA) = +GVAR(nextFrameBufferB);
    GVAR(nextFrameBufferB) = [];
    GVAR(nextFrameNo) = diag_frameNo + 1;


    if !(GVAR(deletedIndices) isEqualTo []) then {
        {
            GVAR(perFrameHandlerArray) set [_x, objNull];
        } forEach GVAR(deletedIndices);

        GVAR(perFrameHandlerArray) = GVAR(perFrameHandlerArray) - [objNull];

        {
            _x params ["", "", "", "", "", "_handle"];
            GVAR(PFHhandles) set [_handle, _forEachIndex];
        } forEach GVAR(perFrameHandlerArray);
        GVAR(deletedIndices) = [];
    };

    PERFORMANCECOUNTER_END(PFHCounter);
};


GVAR(OnEachFrameID) = addMissionEventHandler ["EachFrame", {call FUNC(onEachFrameHandler)}];
