#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Trigger Event on a target

    Parameter(s):
    0: Event Name <String> (Default: "EventError")
    1: Target <Array, Group, Number, Object, Side, String> (Default: objNull)
    2: Arguments <Any> (Default: [])

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_event", "EventError", [""]],
    ["_target", objNull, [[], grpNull, 0, objNull, sideUnknown, ""], []],
    ["_args", [], []]
];

// Exit if the Unit is Local
if (_target isEqualType objNull && {local _target}) exitWith {
    [_event, _args] call CFUNC(localEvent);
};

// Exit if the target is a string
if (_target isEqualType "") exitWith {
    private _targets = [];
    // If the string a Class in CfgVehicles then get all objects of the kind and send the code it them
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
        #ifdef ISDEV
            [[_event, _args, (if (isDedicated) then {"2"} else {(format ["%1:%2", profileName, CGVAR(playerUID)])})], QCFUNC(localEvent), _targets] call CFUNC(remoteExec);
        #else
            [[_event, _args], QCFUNC(localEvent), _targets] call CFUNC(remoteExec);
        #endif
    };
};
#ifdef ISDEV
    [[_event, _args, (if (isDedicated) then {"2"} else {(format ["%1:%2", profileName, CGVAR(playerUID)])})], QCFUNC(localEvent), _target] call CFUNC(remoteExec);
#else
    [[_event, _args], QCFUNC(localEvent), _target] call CFUNC(remoteExec);
#endif
