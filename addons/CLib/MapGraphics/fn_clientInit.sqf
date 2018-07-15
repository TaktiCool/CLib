#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Client Init of Map Graphics

    Parameter(s):
    None

    Returns:
    None
*/

"drawmapgraphics" call CFUNC(addIgnoredEventLog);

// Array of Map Controls
with uiNamespace do {
    GVAR(MapGraphicsMapControls) = [];
};

//Namespace for Layer
GVAR(MapGraphicsGroup) = call CFUNC(createNamespace);

//Render Cache
GVAR(MapGraphicsCacheBuildFlag) = 0; // Should be incremented for each rebuild
GVAR(MapGraphicsCacheVersion) = 0;
GVAR(MapGraphicsCache) = [];

GVAR(MapGraphicsGeometryCache) = [];

[{
    ((findDisplay 12) displayCtrl 51) call CFUNC(registerMapControl);
}, {!(isNull ((findDisplay 12) displayCtrl 51))}] call CFUNC(waitUntil);

GVAR(CuratorMapCheckRunning) = true;
[{
    GVAR(CuratorMapCheckRunning) = false;
    ((findDisplay 312) displayCtrl 50) call CFUNC(registerMapControl);
}, {!(isNull ((findDisplay 312) displayCtrl 50))}] call CFUNC(waitUntil);

["inCuratorChanged", {
    (_this select 0) params ["_new"];
    if !(_new) exitWith {};
    if (GVAR(CuratorMapCheckRunning)) exitWith {};
    GVAR(CuratorMapCheckRunning) = true;
    [{
        GVAR(CuratorMapCheckRunning) = false;
        ((findDisplay 312) displayCtrl 50) call CFUNC(registerMapControl);
    }, {!(isNull ((findDisplay 312) displayCtrl 50))}] call CFUNC(waitUntil);
}] call CFUNC(addEventhandler);

[{
    ((uiNamespace getVariable "RscCustomInfoMiniMap") displayCtrl 101) call CFUNC(registerMapControl);
}, {!(isNull (uiNamespace getVariable "RscCustomInfoMiniMap"))}] call CFUNC(waitUntil);
