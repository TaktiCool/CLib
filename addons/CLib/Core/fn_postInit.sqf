#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    This is a experimental version of autoload that uses onPlayerConnected

    Parameter(s):
    None

    Returns:
    None
*/

if ((getNumber (missionConfigFile >> (QPREFIX + "_useExperimentalAutoload"))) isEqualTo 1) then {
    addMissionEventHandler ["PlayerConnected", {
        params ["", "", "", "", "_owner"];
        [] remoteExec [QCFUNC(loadModules), _owner];
    }];

    call CFUNC(loadModules); // call LoadModules on Server
};
