#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Compatible magazines for weapon and muzzle

    Parameter(s):
    0: Weapon Name <String> (Default: "")
    1: Muzzle Name <String> (Default: "")

    Returns:
    List of all Compatible Magazines of a Weapons Muzzle <Array>
*/

params [
    ["_weapon", "", [""]],
    ["_muzzle", "", [""]]
];

if (toLowerANSI _muzzle == "this") then {_muzzle = ""};
private _if = if (_muzzle != "");
private _varName = format ["%1_%2", QGVAR(mags), _weapon];
_if then {
    _varName = format ["%1_%2_%3", QGVAR(mags), _weapon, _muzzle];
};

_varName = toLowerANSI _varName;
if (isNil QGVAR(compatibleMagazinesNamespace)) then {
    GVAR(compatibleMagazinesNamespace) = createHashMap;
};

private _mags = GVAR(compatibleMagazinesNamespace) get _varName;
if !(isNil "_mags") exitWith {_mags};
private _cfgWeapons = configFile >> "CfgWeapons" >> _weapon;
_if then {
    _cfgWeapons = _cfgWeapons >> _muzzle;
};
_mags = getArray (_cfgWeapons >> "magazines");

private _cfgMagazineWells = configFile >> "CfgMagazineWells";

{
    {
        _mags append (getArray _x);
    } forEach configProperties [_cfgMagazineWells >> _x, "isArray _x", true];
} forEach (getArray (_cfgWeapons >> "magazineWell"));

{
    scopeName "loop";
    private _class = configName _x;
    private _cfg = _x;
    private _inGroup = false;
    {
        if (_class in (getArray (_cfg >> "magazineGroup"))) then {
            _inGroup = true;
            breakTo "loop";
        };
    } forEach (getArray (_cfgWeapons >> "magazines"));

    if (_inGroup) then {
        _mags pushBackUnique _class;
    };
} forEach configProperties [configFile >> "CfgMagazines", "isClass _x", true];

_mags = _mags arrayIntersect _mags;
_mags = _mags - ["this"];
GVAR(compatibleMagazinesNamespace) set [_varName, _mags];
_mags
