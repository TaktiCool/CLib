#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Trigger Event on a Target

    Parameter(s):
    0: Event Name <String>
    1: Target <Object, Number, String, Array>
    2: Arguments <Any> (default: nil)

    Returns:
    None
*/
params [["_event", "EventError", [""]], ["_target", objNull, ["", objNull, 0, [], grpNull, sideUnknown]], ["_args", []]];
// exit if the Unit is Local
if (_target isEqualType objNull && {local _target}) exitWith {
    [_event, _args] call CFUNC(localEvent);
};

// exit if the target is a string
if (_target isEqualType "") exitWith {
    private _targets = [];
    // if the string a Class in CfgVehicles then get all objects of the kind and send the code it them
    if ((toLower _target) in ["west", "east", "resistance", "civilian"]) then {
        {
            if (_target isEqualTo (str (side (group _x)))) then {
                _targets pushBack _x;
            };
            nil
        } count allPlayers;
    } else {
        if (isClass (configFile >> "CfgVehicles" >> _target)) then {
            _targets = allMissionObjects _target;
        } else {
            // check all Players if the target String is not a Class
            {
                if (getPlayerUID _x isEqualTo _target) then {
                    _targets pushBack _x;
                };
                nil
            } count allPlayers;
        };
    };
    if (count _targets != 0) then {
        #ifdef isDev
            // [_event, _args, (if (isDedicated) then {"2"} else {(format ["%1:%2", profileName, CGVAR(playerUID)])})] remoteExecCall [QCFUNC(localEvent), _targets];
            [[_event, _args, (if (isDedicated) then {"2"} else {(format ["%1:%2", profileName, CGVAR(playerUID)])})], QCFUNC(localEvent), _targets] call CFUNC(remoteExec);
        #else
            // [_event, _args] remoteExecCall [QCFUNC(localEvent), _targets];
            [[_event, _args], QCFUNC(localEvent), _targets] call CFUNC(remoteExec);
        #endif
    };
};
#ifdef isDev
    // [_event, _args, (if (isDedicated) then {"2"} else {(format ["%1:%2", profileName, CGVAR(playerUID)])})] remoteExecCall [QCFUNC(localEvent), _target];
    [[_event, _args, (if (isDedicated) then {"2"} else {(format ["%1:%2", profileName, CGVAR(playerUID)])})], QCFUNC(localEvent), _target] call CFUNC(remoteExec);
#else
    // [_event, _args] remoteExecCall [QCFUNC(localEvent), _target];
    [[_event, _args], QCFUNC(localEvent), _target] call CFUNC(remoteExec);
#endif
