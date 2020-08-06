#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init

    Parameter(s):
    None

    Returns:
    None
*/

private _modCredits = [];

private _fnc_readAuthorData = {
    {
        private _configPath = (configFile >> "CfgPatches" >> _x);
        private _modData = modParams [_x, ["name"]];
        private _name = _modData param [0, configName _configPath];
        if (isText (_configPath >> "name")) then {
            _name = getText (_configPath >> "name");
        };
        private _authors = getArray (_configPath >> "authors");
        private _author = getText (_configPath >> "author");
        private _url = getText (_configPath >> "url");
        if (_url == "") then {
            _url = getText (_configPath >> "authorUrl");
        };
        private _version = getText (_configPath >> "versionStr");
        if (_version == "") then {
            _version = str (getNumber (_configPath >> "version"));
        };
        _modCredits pushBackUnique [_name, _author, _authors, _url, _version];
        nil
    } count configSourceAddonList _this;
};
private _modClassNames = [];
{
    _x call _fnc_readAuthorData;
    _modClassNames pushBackUnique (configName _x);
    nil
} count configProperties [configFile >> "CfgCLibModules", "isClass _x", true];

(configFile >> "CfgCLibModules") call _fnc_readAuthorData;

private _mods = [];
private _modules = [];
private _fnc_addModules = {
    params ["_mod", "_module"];
    private _index = _mods find _mod;
    if (_index == -1) then {
        _index = _mods pushback _mod;
        _modules pushBack [];
    };
    private _moduleList = _modules select _index;
    _moduleList pushBackUnique _module;
    _modules set [_index, _moduleList];
};
{
    (_x splitString "/\") params [["_mod", "CLib"], ["_module", ""]];
    if (_module == "") then {
        {
            [_mod, configName _x] call _fnc_addModules;
            nil
        } count configProperties [(configFile >> "CfgCLibModules" >> _mod), "isClass _x", true];
    } else {
        [_mod, _module] call _fnc_addModules;
    };
    nil
} count GVAR(LoadedModules);

GVAR(textModules) = "Loaded Modules: <br/>";
{
    private _name = _x;
    private _index = _modClassNames find _name;
    if (_index != -1) then {
        _name = (_modCredits select _index) select 0;
        DUMP("Better Name Found for: " + _name + " " + _x);
    };
    GVAR(textModules) = GVAR(textModules) + format ["<br/> %1", _name];
    {
        GVAR(textModules) = GVAR(textModules) + format ["<br/>  -  %1", _x];
        nil
    } count (_modules select _forEachIndex);
    GVAR(textModules) = GVAR(textModules) + "<br/>";
} forEach _mods;

GVAR(textMods) = "Loaded Mods: <br/>";
{
    _x params ["_name", "_author", "_authorsArr", "_url", "_version"];
    private _authors = "";
    {
        _authors = _authors + format ["%1, ", _x];
        nil
    } count _authorsArr;
    if (_authors == _author) then {
        GVAR(textMods) = GVAR(textMods) + format ["<br/><a href='%4'>%1</a> by %2 Version: %5<br/>", _name, _author, _url, _version];
    } else {
        GVAR(textMods) = GVAR(textMods) + format ["<br/><a href='%4'>%1</a> by %2: %3 Version: %5<br/>", _name, _author, _authors select [0, (count _authors) - 2], _url, _version];
    };
} count _modCredits;

publicVariable QGVAR(textMods);
publicVariable QGVAR(textModules);
