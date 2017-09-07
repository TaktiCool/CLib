#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Server init for settings framework

    Parameter(s):
    None

    Returns:
    None
*/

// store all configs in global namespace
GVAR(allSettings) = [true] call CFUNC(createNamespace);
publicVariable QGVAR(allSettings);

{
    [(getArray _x)] call CFUNC(registerSettings);
} count configProperties [configFile >> "CfgClibSettings", "isArray _x", true];
