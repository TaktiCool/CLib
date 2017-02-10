#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Load and Assign loadout to Unit

    Parameter(s):
    0: Unit that get the Loadout <Unit>
    1: Classname what Loadout the unit will get <String>

    Returns:
    None
*/

params [["_cfg", "", ["", configNull]]];

private _loadoutName = _cfg;
if (_cfg isEqualType "") then {
    _loadoutName = configName _cfg;
};

private _varName = format [QGVAR(Loadout_%1), _loadoutName];

if !(isNil {GVAR(loadoutsNamespace) getVariable _varName}) exitWith {
    GVAR(loadoutsNamespace) getVariable _varName;
};

if (_cfg isEqualType "") then {
    _cfg = (configFile >> "CfgCLibLoadouts" >> _class);
    if (isClass _cfg) exitWith {};
    _cfg = (missionConfigFile >> "CLib" >> "CfgCLibLoadouts" >> _class);
};

if !(isClass _cfg) exitWith {};

private _loadout = [];
private _loadoutVars = [];

private _fnc_assignValue = {
    params ["_name", "_value"];
    _name = toLower _name;
    if (_name in GVAR(defaultLoadoutValues)) then {
        if (_name in _loadout) then {
            private _i = _loadout find _name;
            private _v2 = _loadout select (_i + 1);
            _value append _v2;
            _loadout set [_i + 1, _value];
        } else {
            _loadout append [_name, _value];
        };
    } else {
        if (_name in _loadoutVars) then {
            private _i = _loadoutVars find _name;
            private _v2 = _loadoutVars select (_i + 1);
            _value append _v2;
            _loadoutVars set [_i + 1, _value];
        } else {
            _loadoutVars append [_name, _value];
        };
    };
};

private _fnc_readClass = {
    params ["_config"];
    {
        if (isClass _x) then {
            _x call _fnc_readClass;
        } else {
            _x call _fnc_readData;
        };
        nil
    } count configProperties [_config, "true", true];
};

private _fnc_readData = {
    params ["_config"];

    private _value = switch (true) do {
        case (isText _config): {
            [configName _config, [getText _config]]
        };
        case (isArray _config): {
            [configName _config, getArray _config]
        };
        case (isNumber _config): {
            [configName _config, [getNumber _config]]
        };
    };
    if !(isNil "_value") then {
        _value call _fnc_assignValue;
    };
};

_cfg call _fnc_readClass;
private _return = [_loadout, _loadoutVars];
[GVAR(loadoutsNamespace), _varName, _return, QGVAR(allLoadouts)] call CFUNC(setVariable);
_return
