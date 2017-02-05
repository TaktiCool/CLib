#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Registers config class (from configFile) to settings framework

    Parameter(s):
    0: Array of config path (Array of strings)

    Returns:
    None
*/
params ["_basePath"];
//params ["_configClass"];
_configClass = configFile;
{
    _configClass = (_configClass >> _x);
    nil;
} count _basePath;

//private _basePath = (configHierarchy _configClass) apply {configName _x};
//_basePath deleteAt 0;
private _prefix = _basePath joinString "/";
private _subClasses = [];
private _settings = [];

private _fnc_getValue = {
    if (isText _this) exitWith {
        getText _this;
    };
    if (isNumber _this) exitWith {
        getNumber _this;
    };
    if (isArray _this) exitWith {
        getArray _this;
    };
    nil;
};

private _fnc_getSettingParameters = {
    params ["_baseConfig", "_path"];
    _config = _baseConfig;
    {
        _config = (_config >> _x);
        nil;
    } count _path;

    private _description = nil;
    private _force = "";
    private _value = nil;
    private _isSetting = false;

    if (isClass _config) then {
        if (isText (_config >> "value") || isNumber (_config >> "value") || isArray (_config >> "value")) then {
            _force = getText (_config >> "force");
            _value = (_config >> "value") call _fnc_getValue;
            _description = getText (_config >> "description");
            _isSetting = true;
        } else {
            if (_baseConfig == configFile) then {
                [_path] call CFUNC(registerSettings);
            };
        };
    } else {
        if (isText _config || isNumber _config || isArray _config) then {
            _value = _config call _fnc_getValue;
            _isSetting = true;
        };
    };
    [_isSetting, _value, _force, _description];
};

{
    private _name = configName _x;
    private _path = _basePath + [_name];

    ([configFile, _path] call _fnc_getSettingParameters) params ["_isSetting", "_value", "_force", "_description"];

    if (_isSetting) then {
        if (toLower _force in ["","mission"]) then {
            ([missionConfigFile, _path] call _fnc_getSettingParameters) params ["_isValid", "_newValue"];
            if (_isValid) then {
                _value = _newValue;
            };
        };
        _settings pushBack _name;
        private _pathString = (_path joinString "/");
        GVAR(allSettings) setVariable [_pathString, [_value, _force, _description], true];
    } else {
        _subClasses pushBack _name;
    };
    true;
} count configProperties [_configClass, "true", true];

GVAR(allSettings) setVariable ["classes:" + _prefix, _subClasses, true];
GVAR(allSettings) setVariable ["settings:" + _prefix, _settings, true];
