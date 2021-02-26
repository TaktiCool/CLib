#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Creates the PFH for transmitting functions

    Parameter(s):
    None

    Returns:
    None
*/

if (isNil QGVAR(PFHSendFunctions)) exitWith {

    GVAR(TransmissionBlockSize) = 3;
    if (isNumber (missionConfigFile >> "CLib" >> "TransmissionBlockSize")) then {
        GVAR(TransmissionBlockSize) = (getNumber (missionConfigFile >> "CLib" >> "TransmissionBlockSize")) max 1;
    };
    GVAR(PFHSendFunctions) = [{
        private _delete = false;
        {
            _x params ["_clientID", "_functionCache", "_index"];
            for "_i" from 0 to ((count _functionCache - 1) min 3) do {
                // Extract the code out of the function.
                private _functionName = _functionCache deleteAt 0;

                [_functionName, _clientID, _index + _i] call FUNC(sendFunctions);
            };

            if (_functionCache isEqualTo []) then {
                GVAR(SendFunctionsUnitCache) set [_forEachIndex, objNull]; // Clear Cache
                _delete = true;
            } else {
                (GVAR(SendFunctionsUnitCache) select _forEachIndex) set [1, _functionCache];
                (GVAR(SendFunctionsUnitCache) select _forEachIndex) set [2, _index + 4];
            };
        } forEach GVAR(SendFunctionsUnitCache);

        // clear Cache
        if (_delete) then {
            GVAR(SendFunctionsUnitCache) = GVAR(SendFunctionsUnitCache) - [objNull];
        };
    }] call CFUNC(addPerFrameHandler);
};
