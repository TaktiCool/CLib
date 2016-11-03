#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    this is a Experimental Version of Autoload that uses onPlayerConnected

    Parameter(s):
    None

    Returns:
    None
*/
if ((getNumber (missionConfigFile >> (QPREFIX + "_useExperimentalAutoload"))) isEqualTo 1) then {

    [QGVAR(onPlayerConnected), "onPlayerConnected", {
        [] remoteExec [QCFUNC(loadModules), _owner];
    }] call BIS_fnc_addStackedEventHandler

    call CFUNC(loadModules); // call LoadModules on Server
};
