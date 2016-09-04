#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: BadGuy

    Description:
    Client Init of Map Graphics

    Parameter(s):
    None

    Returns:
    None
*/

// Array of Map Controls
with uiNamespace do {
    GVAR(MapGraphicsMapControls) = [];
};

//Namespace for Layer
GVAR(MapGraphicsGroup) = call FUNC(createNamespace);

//Render Cache
GVAR(MapGraphicsCacheBuildFlag) = 0; // Should be incremented for each rebuild
GVAR(MapGraphicsCacheVersion) = 0;
GVAR(MapGraphicsCache) = [];

GVAR(MapGraphicsGeometryCache) = [];

[{
    ((findDisplay 12) displayCtrl 51) call FUNC(registerMapControl);
}, {!(isNull ((findDisplay 12) displayCtrl 51))}] call FUNC(waitUntil);

[{
    ((uiNamespace getVariable "RscMiniMap") displayCtrl 101) call FUNC(registerMapControl);
}, {!(isNull (uiNamespace getVariable "RscMiniMap"))}] call FUNC(waitUntil);
