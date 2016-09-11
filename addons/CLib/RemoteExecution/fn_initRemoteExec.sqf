#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: joko // Jonas

    Description:
    Client Init for Remote Exec Fallback that add the PublicVariableEventhanlder

    Parameter(s):
    None

    Returns:
    None
*/

QGVAR(remoteExecCode) addPublicVariableEventHandler {
    (_this select 1) call CFUNC(execute);
};
GVAR(useRemoteFallback) = getNumber (missionConfigFile >> "useRemoteExecFallback") isEqualTo 1;
