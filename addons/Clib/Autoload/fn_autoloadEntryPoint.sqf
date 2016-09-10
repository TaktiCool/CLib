#include "macros.hpp"
/*
    Comunity Lib - Clib

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
    GVAR(useFunctionCompression) = getNumber(missionConfigFile >> "useCompressedFunction") isEqualTo 1;

    publicVariable QGVAR(useFunctionCompression);

    publicVariable QCFUNC(decompressString);
    publicVariable QCFUNC(loadModules);
};
