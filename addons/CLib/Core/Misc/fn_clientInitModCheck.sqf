#include "macros.hpp"
/*
    Community Lib - CLib
    Author: joko // Jonas
    Description:
    Server for Core Module
    Parameter(s):
    None
    Returns:
    None
*/

DFUNC(clearAddons) = {
    params ["_addons", "_ignore"];

    _addons params ["_name", "_version"];
    {
        if (_x in _ignore) then {
            _name set [_forEachIndex, objNull];
            _version set [_forEachIndex, objNull];
        };
    } forEach (_addons select 0);

    _name = _name - [objNull];
    _version = _version - [objNull];

    [_name, _version]
};


[{
    GVAR(serverAddons) params ["_allServerAdons", "_ignoredAddons"];

    _ignoredAddons append getArray (missionConfigFile >> "CLib_IgnoredAddons");

    _allServerAdons = _allServerAdons call FUNC(clearAddons);

    _allServerAdons params ["_namesServer", "_versionsServer"];

    private _loadedAddons = call FUNC(getAllAddons);

    _loadedAddons = _loadedAddons call FUNC(clearAddons);

    _loadedAddons params ["_namesClient", "_versionsClient"];

    private _addonsIntersect = _namesServer arrayIntersect _namesClient

    private _missingServer = _namesServer - _addonsIntersect;

    private _missingClient = _namesClient - _addonsIntersect;

    {
        LOG("Missing ClientSide Mod: " + _x)
        nil
    } count _missingClient;

    {
        LOG("Addons is Missing on Server: " + _x)
        nil
    } count _missingServer;

    {
        private _clientVersion = _versionsClient select (_namesClient find _x);
        private _serverVersion = _versionsServer select (_namesServer find _x);
        if !(_clientVersion isEqualTo _serverVersion) then {
            LOG("Version Missmatch in Addon " + str _x + " Server Version: " + str _serverVersion + "Client Version: " + str _clientVersion)
        };
        nil
    } count _addonsIntersect;

}, {
    !isNil QGVAR(serverAddons)
}] call CFUNC(waitUntil);
