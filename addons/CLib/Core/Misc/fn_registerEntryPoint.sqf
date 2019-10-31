#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Function that allows to execute code from the mission direct without using Mission Modules

    Parameter(s):
    0: Code To Execute when CLib is Loaded <Code>
    1: Arguments that get passed to Code <Anything> (Default: nil)

    Returns:
    None
*/
params [["_code", {}, [{}, ""]], ["_arguments", nil, []]];
isNil {
    if (CGVAR(loadingIsFinished)) exitWith {
        if (_code isEqualType "") then {
            _code = missionNamespace getVariable [_code, {LOG("Code not Found")}];
        };
        _arguments call _code;
    };

    if (isNil QCGVAR(entryPointQueue)) then {
        CGVAR(entryPointQueue) = [];
    };
    CGVAR(entryPointQueue) pushBack [_code, _arguments];
};
