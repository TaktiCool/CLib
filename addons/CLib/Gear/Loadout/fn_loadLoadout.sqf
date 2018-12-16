#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Load loadout to Unit

    Parameter(s):
    0: Classname or config of loadout <Config, String> (Default: "")

    Returns:
    None
*/

params [
    ["_cfg", "", [configNull, ""]]
];

private _loadoutName = _cfg;
if (_cfg isEqualType configNull) then {
    _loadoutName = configName _cfg;
};

private _varName = format [QGVAR(Loadout_%1), _loadoutName];

if !(isNil {GVAR(loadoutsNamespace) getVariable _varName}) exitWith {
    GVAR(loadoutsNamespace) getVariable _varName;
};

if (_cfg isEqualType "") then {
    _cfg = missionConfigFile >> "CLib" >> "CfgCLibLoadouts" >> _loadoutName;
    if (isClass _cfg) exitWith {};
    _cfg = configFile >> "CfgCLibLoadouts" >> _loadoutName;

};
if (!isClass _cfg) exitWith {};

private _loadout = call CFUNC(createHash);
private _loadoutVars = call CFUNC(createHash);

private _fnc_assignValue = {
    params ["_key", "_value"];
    _key = toLower _key;
    if (_key in GVAR(defaultLoadoutValues)) then {
        if ([_loadout, _key] call CFUNC(containsKey)) then {
            private _data = [_loadout, _key] call CFUNC(getHash);
            _data append _value;
            [_loadout, _key, _data] call CFUNC(setHash);
        } else {
            [_loadout, _key, _value] call CFUNC(setHash);
        };
    } else {
        if ([_loadoutVars, _key] call CFUNC(containsKey)) then {
            private _data = [_loadoutVars, _key] call CFUNC(getHash);
            _data append _value;
            [_loadoutVars, _key, _data] call CFUNC(setHash);
        } else {
            [_loadoutVars, _key, _value] call CFUNC(setHash);
        };
    };
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

private _fnc_readClass = {
    params ["_config"];
    {
        _x call ([_fnc_readData, _fnc_readClass] select (isClass _x));
        nil
    } count configProperties [_config, "true", true];
};

_cfg call _fnc_readClass;
private _return = [_loadoutVars, _loadout];
[GVAR(loadoutsNamespace), _varName, _return, QGVAR(allLoadouts), true] call CFUNC(setVariable);
_return
