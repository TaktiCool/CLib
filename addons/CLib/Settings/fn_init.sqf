#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Init for settings

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(settingsNamespaceOld) = call CFUNC(createNamespace);

if (isServer) then {
    call FUNC(server);
};

if (hasInterface) then {
    call FUNC(client);
};
