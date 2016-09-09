#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: joko // Jonas

    Description:
    Server for Core Module

    Parameter(s):
    None

    Returns:
    None
*/

// add Eventhandler for Remote Logging
DFUNC(log) = {
    params [["_log", "", [""]], ["_file", "", [""]]];
    _file = _file call CFUNC(sanitizeString);
    "Clib_server" callExtension (format ["logging:%1:", _file] + _log);
};

QGVAR(sendlogfile) addPublicVariableEventHandler {
    (_this select 1) call CFUNC(log);
};
