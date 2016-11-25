#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Handles income data and process it and sending it to the other clients if required

    Parameter(s):
    0: Arguments for the function/command <Any>
    1: Function/Command that get executed on the remote Clients <String>
    2: Target to what the Event should get sendet <Number, Side, Object, Group, Array of Prev named Types>

    Returns:
    None
*/
params ["_args", ["_function", "", [""]], ["_target", 0, [0, sideUnknown, objNull, grpNull, []]]];

// target must be a Array
if !(_target isEqualType []) then {
    _target = [_target];
};

private _targets = [];


{
    private _var = _x;
    switch (typeName _var) do {
        case ("SIDE"): {
            // if _var is Side get all Units From on side and apply the Owner on it
            _targets append ((allUnits select {_x == _var}) apply {owner _x});
        };
        case ("OBJECT"): {
            // if _var is Object pushback the Owner netID
            _targets pushBack (owner _x);
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
            _targets append ((units _x) apply {owner _x});
        };
        /* currently not supported in RemoteExecution fallback
        case ("STRING");
        */
    };
    nil
} count _target;

// exit with no targets are applyed
if !(_targets isEqualTo []) then {
    // make Targets Uniqe
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
