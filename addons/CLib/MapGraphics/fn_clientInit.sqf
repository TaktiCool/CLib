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

["missionStarted", {
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
        if (GVAR(CuratorMapCheckRunning)) exitWith {};
        GVAR(CuratorMapCheckRunning) = true;
        [{
            GVAR(CuratorMapCheckRunning) = false;
            ((findDisplay 312) displayCtrl 50) call CFUNC(registerMapControl);
        }, {!(isNull ((findDisplay 312) displayCtrl 50))}] call CFUNC(waitUntil);
    }] call CFUNC(addEventhandler);

    GVAR(EGSpectatorMapCheckRunning) = true;
    [{
        GVAR(EGSpectatorMapCheckRunning) = false;
        ((uiNamespace getVariable "RscDisplayEGSpectator") displayCtrl 62609) call CFUNC(registerMapControl);
    }, {!(isNull ((uiNamespace getVariable "RscDisplayEGSpectator") displayCtrl 62609))}] call CFUNC(waitUntil);

    ["inEGSpectatorChanged", {
        (_this select 0) params ["_new"];
        if (GVAR(EGSpectatorMapCheckRunning)) exitWith {};
        GVAR(EGSpectatorMapCheckRunning) = true;
        [{
            GVAR(EGSpectatorMapCheckRunning) = false;
            ((uiNamespace getVariable "RscDisplayEGSpectator") displayCtrl 62609) call CFUNC(registerMapControl);
        }, {!(isNull ((uiNamespace getVariable "RscDisplayEGSpectator") displayCtrl 62609))}] call CFUNC(waitUntil);
    }] call CFUNC(addEventhandler);

    GVAR(GPSMapCheckRunning) = true;
    [{
        GVAR(GPSMapCheckRunning) = false;
        ((uiNamespace getVariable "RscCustomInfoMiniMap") displayCtrl 101) call CFUNC(registerMapControl);
    }, {!(isNull (uiNamespace getVariable "RscCustomInfoMiniMap"))}] call CFUNC(waitUntil);

    ["visibleGPSChanged", {
        if (GVAR(GPSMapCheckRunning)) exitWith {};
        GVAR(GPSMapCheckRunning) = true;
        [{
            GVAR(GPSMapCheckRunning) = false;
            ((uiNamespace getVariable "RscCustomInfoMiniMap") displayCtrl 101) call CFUNC(registerMapControl);
        }, {!(isNull (uiNamespace getVariable "RscCustomInfoMiniMap"))}] call CFUNC(waitUntil);
    }] call CFUNC(addEventhandler);

    ["vehicleChanged", {
        if (GVAR(GPSMapCheckRunning)) exitWith {};
        GVAR(GPSMapCheckRunning) = true;
        [{
            GVAR(GPSMapCheckRunning) = false;
            ((uiNamespace getVariable "RscCustomInfoMiniMap") displayCtrl 101) call CFUNC(registerMapControl);
        }, {!(isNull (uiNamespace getVariable "RscCustomInfoMiniMap"))}] call CFUNC(waitUntil);
    }] call CFUNC(addEventhandler);
}] call CFUNC(addEventhandler);
