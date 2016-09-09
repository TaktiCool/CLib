#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: joko // Jonas

    Description:
    Server Init for Remote Exec Fallback that add the PublicVaraibleEventhandler

    Parameter(s):
    None

    Returns:
    None
*/

QGVAR(remoteServerData) addPublicVariableEventHandler {
    (_this select 1) call CFUNC(handleIncomeData);
};
