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

[{
    GVAR(serverAddons) params ["_allServerAdons", "_ignoredAddons"];

    _ignoredAddons append getArray (missionConfigFile >> "CLib_IgnoredAddons");

    _allServerAdons params ["_namesServer", "_versionsServer"];

    private _loadedAddons = call FUNC(getAllAddons);

    _loadedAddons = [_loadedAddons, _ignoredAddons] call FUNC(clearAddons);

    _loadedAddons params ["_namesClient", "_versionsClient"];

    private _addonsIntersect = _namesServer arrayIntersect _namesClient;

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
