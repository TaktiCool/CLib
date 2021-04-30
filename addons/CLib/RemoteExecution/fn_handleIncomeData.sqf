#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Handles income data and process it and sending it to the other clients if required

    Parameter(s):
    0: Target to what the Event should get sendet <Number, Object, Side, Group, Array> (Default: 0)
    1: Arguments for the function or command <Anything> (Default: [])
    2: Function or command that get executed on the remote clients <String> (Default: "")

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_target", 0, [0, objNull, sideUnknown, grpNull, []], []],
    ["_args", [], []],
    ["_function", "", [""]]
];

// target must be a Array
if !(_target isEqualType []) then {
    _target = [_target];
};

private _targets = [];

{
    private _var = _x;
    switch (typeName _var) do {
        /* currently not supported in RemoteExecution fallback
        case ("STRING");
        */
        case ("SIDE"): {
            // if _var is Side get all Units From on side and apply the Owner on it
            _targets append ((units _var) apply {owner _x});
        };
        case ("OBJECT"): {
            // if _var is Object pushback the Owner netID
            _targets pushBack (owner _var);
        };
        case ("NUMBER"): {
            // if _var is Number 0 than Add All Units as Targets
            if (_var == 0) exitWith {
                _targets append (allUnits apply {owner _x});
            };
            // if _var is Number smaller 0 than Add All Units as Targets and substract abs value of _var
            if (_var <= 0) exitWith {
                _targets append ((allUnits apply {owner _x}) - [abs _var]);
            };
            // pushback _var in Targets if Prev Condition not catched ad execute only on this netID
            _targets pushBack _var;
        };
        case ("GROUP"): {
            // if _var is Gruop get all Units from group with netID
            _targets append ((units _var) apply {owner _x});
        };
    };
    nil
} count _target;

// exit with no targets are applyed
if (_targets isNotEqualTo []) then {
    // make Targets Unique
    _targets = _targets arrayIntersect _targets;

    GVAR(remoteExecCode) = [_function, _args];

    {
        if (_x == 2) then {
            [_function, _args] call FUNC(execute);
        } else {
            _x publicVariableClient QGVAR(remoteExecCode);
        };
        nil
    } count _targets;
};

nil // this function should return Nothing
