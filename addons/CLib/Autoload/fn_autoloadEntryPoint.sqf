#include "macros.hpp"
/*
    Comunity Lib - CLib

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
    GVAR(useRemoteFallback) = getNumber(missionConfigFile >> (QPREFIX + "_useFallbackRemoteExecution")) isEqualTo 1;
    GVAR(useFunctionCompression) = getNumber(missionConfigFile >> (QPREFIX + "_useCompressedFunction")) isEqualTo 1;

    publicVariable QGVAR(useFunctionCompression);
    publicVariable QGVAR(useRemoteFallback);

    publicVariable QCFUNC(decompressString);
    publicVariable QCFUNC(loadModules);
};
