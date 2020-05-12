#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    This function is the entry point for the core module. It is called by autoloader for server. It adds OEF EH to trigger some common events.

    Parameter(s):
    None

    Returns:
    None
*/

// To ensure that the briefing is done during briefings we trigger an event if the mission starts.
GVAR(jipQueue) = [];

if (isDedicated) then {
    [{
        // If time is greater than zero trigger the event and remove the OEF EH to ensure that the event is only triggered once.
        ["missionStarted", displayNull] call CFUNC(localEvent);
    }, {(time > 0)}] call CFUNC(waitUntil);
};

["registerJIPQueue", {
    GVAR(jipQueue) pushBack (_this select 0);
}] call CFUNC(addEventhandler);

["loadJIPQueue", {
    (_this select 0) params ["_target"];
    (owner _target) publicVariableClient QGVAR(jipQueue);
}] call CFUNC(addEventhandler);
