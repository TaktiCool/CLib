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

GVAR(Namepace) = true call CFUNC(createNamespace);
GVAR(supportedLanguages) = [];

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
    private _var = GVAR(Namepace) getVariable [_locName, []];
    _var set [_index, _data];

    [GVAR(Namepace), _locName, _var, QGVAR(allLocalisations), true] call CFUNC(setVariable);
};

private _fnc_readLocalisation = {
    params ["_config", "_name"];
    {
        [_name, configName _x, getText _x] call _fnc_setLanguageKey;
        nil
    } count configProperties [_config, "isText _x", true];
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

publicVariable QGVAR(Namepace);
publicVariable QGVAR(supportedLanguages);
