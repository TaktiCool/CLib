#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    Execute RemoteExecCommands

    Remarks:
    Internal Function

    Parameter(s):
    0: Function or Command that get Executed <String>
    1: Arguments that passes to the Event;

    Returns:
    Function Return <Any>
*/
params ["_function", "_args"];
if (!isNil _function && {!((currentNamespace getVariable _function) isEqualType {})}) then {
    _args call (currentNamespace getVariable _function);
} else {
    LOG("ERROR: Unknown Function: " + _function)
};
