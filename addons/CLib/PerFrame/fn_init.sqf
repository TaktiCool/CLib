#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    init for PFH

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(waitArray) = [];
GVAR(waitUntilArray) = [];
GVAR(perFrameHandlerArray) = [];
GVAR(PFHhandles) = [];
GVAR(nextFrameBufferA) = [];
GVAR(nextFrameBufferB) = [];
GVAR(nextFrameNo) = diag_frameno;
CGVAR(deltaTime) = diag_tickTime - (diag_tickTime/10000);
GVAR(lastFrameTime) = diag_tickTime;
GVAR(sortWaitArray) = false;
GVAR(OnEachFrameID) = addMissionEventHandler ["EachFrame", {
    if (getClientState == "GAME FINISHED") exitWith {
        removeMissionEventHandler ["EachFrame", GVAR(OnEachFrameID)];
    };

    PERFORMANCECOUNTER_START(PFHCounter)

    // Delta time Describe the time that the last Frame needed to calculate this is required for some One Each Frame Balance Math Calculations
    CGVAR(deltaTime) = diag_tickTime - GVAR(lastFrameTime);
    GVAR(lastFrameTime) = diag_tickTime;

    {
        _x params ["_function", "_delay", "_delta", "", "_args", "_handle"];

        if (time > _delta) then {
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

    /*
    // Code Ported from ACE changed by joko // Jonas
    while {!(GVAR(waitArray) isEqualTo []) && {GVAR(waitArray) select 0 select 0 <= time}} do {
        private _entry = GVAR(waitArray) deleteAt 0;
        (_entry select 2) call (_entry select 1);
    };
    */

    {
        if (_x select 0 >= time) exitWith {};
        (_x select 2) call (_x select 1);
        _delete = true;
        GVAR(waitArray) set [_forEachIndex, objNull];
    } forEach GVAR(waitArray);

    if (_delete) then {
        GVAR(waitArray) = GVAR(waitArray) - [objNull];
    };

    _delete = false;

     {
        if ((_x select 2) call (_x select 1)) then {
            (_x select 2) call (_x select 0);
            _delete = true;
            GVAR(waitUntilArray) set [_forEachIndex, objNull];
        };
    } forEach GVAR(waitUntilArray);


    if (_delete) then {
        GVAR(waitUntilArray) = GVAR(waitUntilArray) - [objNull];
    };

    //Handle the execNextFrame array:
    {
        (_x select 0) call (_x select 1);
        nil
    } count GVAR(nextFrameBufferA);

    //Swap double-buffer:
    GVAR(nextFrameBufferA) = +GVAR(nextFrameBufferB);
    GVAR(nextFrameBufferB) = [];
    GVAR(nextFrameNo) = diag_frameno + 1;

    PERFORMANCECOUNTER_END(PFHCounter)
}];
