#include "macros.hpp"
/*
    Project Reality ArmA 3

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
if (!isNil _function) then {
    _args call (missionNamespace getVariable _function);
} else {
    call compile format ["(_args select 0) %1 (_args select 1)", _function];
};
