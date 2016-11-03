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
    CGVAR(useRemoteFallback) = getNumber(missionConfigFile >> (QPREFIX + "_useFallbackRemoteExecution")) isEqualTo 1;
    CGVAR(useFunctionCompression) = getNumber(missionConfigFile >> (QPREFIX + "_useCompressedFunction")) isEqualTo 1;

    publicVariable QCGVAR(useFunctionCompression);
    publicVariable QCGVAR(useRemoteFallback);

    publicVariable QCFUNC(decompressString);
    publicVariable QCFUNC(loadModules);
};
