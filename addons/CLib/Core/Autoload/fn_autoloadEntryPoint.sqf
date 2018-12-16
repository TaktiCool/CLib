#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Entry point for autoloader. This should be the first called function for everything to work properly.
    Provides an entry point for all clients. Must be called in preInit.

    Parameter(s):
    None

    Returns:
    None
*/

// Transfers entry function from server to all clients.
if (isServer) then {
    CGVAR(useRemoteFallback) = getNumber (missionConfigFile >> QPREFIX >> "useFallbackRemoteExecution") isEqualTo 1;
    CGVAR(useCompression) = getNumber (missionConfigFile >> QPREFIX >> "useCompression") isEqualTo 1;
    CGVAR(useExperimentalAutoload) = (getNumber (missionConfigFile >> QPREFIX >> "useExperimentalAutoload")) isEqualTo 1;
    CGVAR(loadingIsFinished) = false;

    publicVariable QCGVAR(useCompression);
    publicVariable QCGVAR(useRemoteFallback);
    publicVariable QCGVAR(useExperimentalAutoload);
    publicVariable QCGVAR(loadingIsFinished);

    publicVariable QCFUNC(decompressString);
    publicVariable QCFUNC(loadModules);
    publicVariable QCFUNC(registerEntryPoint);
};
