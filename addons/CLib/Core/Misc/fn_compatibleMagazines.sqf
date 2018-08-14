#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Compatible Magazines for Weapon/Muzzle

    Parameter(s):
    None

    Returns:
    None
*/
params ["_weapon", "_muzzle"];
private _if = if (_muzzle != "");
private _varName = format ["%1_%2_%3", QGVAR(mags), _weapon];
_if then {
    _varName = format ["%1_%2_%3_%4", QGVAR(mags), _weapon, _muzzle];
};

if (isNil QGVAR(compatibleMagazinesNamespace)) then {
    GVAR(compatibleMagazinesNamespace) = false call CFUNC(createNamespace);
};

private _mags = GVAR(compatibleMagazinesNamespace) getVariable _varName;
if !(isNil "_mags") exitWith { _mags };
private _cfgWeapons = configFile >> "CfgWeapons" >> _weapon;
_if then {
    _cfgWeapons = _cfgWeapons >> _muzzle;
};
_mags = getArray (_cfgWeapons >> "magazines");

private _cfgMagazineWells = configFile >> "CfgMagazineWells";

{
    {
        _mags append (getArray _x);
        nil
    } count configProperties [_cfgMagazineWells >> _x, "isArray _x", true];
    nil
} count (getArray (_cfgWeapons >> "magazineWell"));

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
        nil
    } count (getArray (_cfgWeapons >> "magazines"));

    if (_inGroup) then {
        _mags pushBackUnique _class;
    };
    nil
} count configProperties [configFile >> "CfgMagazines", "isClass _x", true];

_mags = _mags arrayIntersect _mags;
_mags = _mags - ["this"];
GVAR(compatibleMagazinesNamespace) setVariable [_varName, _mags];
_mags
