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
GVAR(deletedIndices) = [];

GVAR(skipFrameArray) = [];
GVAR(sortSkipFrameArray) = false;

GVAR(currentFrameBuffer) = [];
GVAR(nextFrameBuffer) = [];
GVAR(nextFrameNo) = diag_frameNo;

CGVAR(deltaTime) = diag_deltaTime max 0.000001;
GVAR(lastFrameTime) = time;

GVAR(OnEachFrameID) = addMissionEventHandler ["EachFrame", {call FUNC(onEachFrameHandler)}];
