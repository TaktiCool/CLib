#include "macros.hpp"
/*
    Comunity Lib - CLib

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
