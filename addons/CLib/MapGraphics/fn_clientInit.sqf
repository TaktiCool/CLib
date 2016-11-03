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

[{
    ((uiNamespace getVariable "RscMiniMap") displayCtrl 101) call CFUNC(registerMapControl);
}, {!(isNull (uiNamespace getVariable "RscMiniMap"))}] call CFUNC(waitUntil);
