#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Server init for localization

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(ServerNamespace) = true call CFUNC(createNamespace);
GVAR(supportedLanguages) = [];
// GVAR(supportedLanguages) = getArray(configFile >> "CfgCLibLocalisation" >> "supportedLanguages"); // disabled this so we have a Dynamic Supported languages

private _fnc_languageIndex = {
    private _index = GVAR(supportedLanguages) find _this;
    if (_index == -1) exitWith {
        GVAR(supportedLanguages) pushBackUnique _this
    };
    _index
};

private _fnc_setLanguageKey = {
    params ["_name", "_index", "_data"];

    _index = _index call _fnc_languageIndex;

    private _locName = format ["STR_%1", _name];
    private _var = GVAR(ServerNamespace) getVariable [_locName, []];
    /* TODO Fix Compression
    if (USECOMPRESSION) then {
        _data = _data call CFUNC(compressString);
    };
    */
    _var set [_index, _data];

    [GVAR(ServerNamespace), _locName, _var, QGVAR(allLocalisations), true] call CFUNC(setVariable);
};

private _fnc_readLocalisation = {
    params ["_config", "_name"];
    private _allLocalisations = [];
    {
        [_name, configName _x, getText _x] call _fnc_setLanguageKey;
    } forEach configProperties [_config, "isText _x", true];
};

private _fnc_readLocalisationClass = {
    params ["_config", "_name"];
    private _childs = configProperties [_config, "isClass _x", true];
    if (count _childs == 0) then {
        [_config, _name] call _fnc_readLocalisation;
    } else {
        {
            [_x, _name + "_" + configName _x] call _fnc_readLocalisationClass;
            nil
        } count _childs;
    };
};

{
    {
        [_x, configName _x] call _fnc_readLocalisationClass;
        nil
    } count configProperties [_x >> "CfgCLibLocalisation", "isClass _x", true];
    nil
} count [campaignConfigFile, missionConfigFile >> "CLib", configFile];

publicVariable QGVAR(ServerNamespace);
publicVariable QGVAR(supportedLanguages);
