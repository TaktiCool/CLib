#include "macros.hpp"

if (isNil QFUNC(compile)|| isNil QFUNC(compressString) || isNil QFUNC(decompressString) || isNil QFUNC(stripSqf)) then {
    DFUNC(compile) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(compile));
    DFUNC(compressString) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(compressString));
    DFUNC(decompressString) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(decompressString));
    DFUNC(stripSqf) = compile preprocessFileLineNumbers QUOTE(FUNCPATH(stripSqf));
};

/*
#ifndef isDev
    private _extRet = "PRA3_server" callExtension "version";
    GVAR(serverExtensionExist) = _extRet != "" && {getText(configFile >> "PRA3" >> "PRA3_Extension" >> "version") == _extRet};
#endif
*/

// Version Informations
private _missionVersionStr = "";
private _missionVersionAr = getArray(missionConfigFile >> "PRA3" >> "Version");

private _serverVersionStr = "";
private _serverVersionAr = getArray(configFile >> "CfgPatches" >> "PRA3_Server" >> "versionAr");

{
    _missionVersionStr = _missionVersionStr + str(_x) + ".";
    nil
} count _missionVersionAr;

{
    _serverVersionStr = _serverVersionStr + str(_x) + ".";
    nil
} count _serverVersionAr;

// TODO Create Database for Compatible Versions
if (!(_missionVersionAr isEqualTo _serverVersionAr) && (isClass (missionConfigFile >> "PRA3"))) then {
    ["Lost"] call BIS_fnc_endMissionServer
};

_missionVersionStr = _missionVersionStr select [0, (count _missionVersionStr - 1)];
_serverVersionStr = _serverVersionStr select [0, (count _serverVersionStr - 1)];
GVAR(VersionInfo) = [[_missionVersionStr,_missionVersionAr], [_serverVersionStr, _serverVersionAr]];
publicVariable QGVAR(VersionInfo);

private _tempName = [];
private _tempRequires = [];
{
    _tempName pushBack (configName _x);
    _tempRequires pushBack (getArray (_x >> "require"));
    nil
} count ("true" configClasses (configFile >> "CLib_Dependencies"));
GVAR(Dependencies) = [_tempName,_tempRequires];

// The autoloader uses this array to get all function names.
GVAR(functionCache) = [];

#include "PREP.hpp"

// We call the autoloader here. This starts the mod work.
call FUNC(autoloadEntryPoint);
