#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init for Localization

    Parameter(s):
    None

    Returns:
    None
*/

if (isServer) then {
    call FUNC(server);
};

if (hasInterface) then {
    call FUNC(client);
};
