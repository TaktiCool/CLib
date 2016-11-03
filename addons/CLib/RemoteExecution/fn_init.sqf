#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Client Init for Remote Exec Fallback that add the PublicVariableEventhanlder

    Parameter(s):
    None

    Returns:
    None
*/

QGVAR(remoteExecCode) addPublicVariableEventHandler {
    (_this select 1) call FUNC(execute);
};
GVAR(useRemoteFallback) = getNumber (missionConfigFile >> "useRemoteExecFallback") isEqualTo 1;
