#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: NetFusion

    Description:
    Calls all init functions of all required modules for server and client. This should be called after modules are loaded (functions transferred).

    Parameter(s):
    None

    Returns:
    None

    Example:
    call FUNC(callModules);
*/
private _init = [];
private _serverInit = [];
private _postInit = [];
private _clientInit = [];
private _hcInit = [];


diag_log format ["[PRA3 - Version]: Server Version %1", (GVAR(VersionInfo) select 1) select 0];
diag_log format ["[PRA3 - Version]: Mission Version %1", (GVAR(VersionInfo) select 0) select 0];

// Cycle through all available functions and determine whether to call them or not.
{
    // Client only functions.
    if (toLower(_x) find "_fnc_clientinit" > 0) then {
        _clientInit pushBack _x;
    };
    // Server only functions.
    if (toLower(_x) find "_fnc_serverinit" > 0) then {
        _serverInit pushBack _x;
    };
    // HC only functions.
    if (toLower(_x) find "_fnc_hcinit" > 0) then {
        _hcInit pushBack _x;
    };
    // Functions for both.
    if (toLower(_x) find "_fnc_init" > 0) then {
        _init pushBack _x;
    };
    if (toLower(_x) find "_fnc_postinit" > 0) then {
        _postInit pushBack _x;
    };
    DUMP("Read requiredFunctions: " + _x)
    nil
} count GVAR(requiredFunctions);

{
    private _time = diag_tickTime;
    _x call (missionNamespace getVariable [_x, {LOG("fail to Call Function: " + _this)}]);
    _time = diag_tickTime - _time;
    LOG("Call: " + _x + " (" + str(_time*1000) +" ms)")
    nil
} count _init;

if (isServer) then {
    {
        private _time = diag_tickTime;
        _x call (missionNamespace getVariable [_x, {LOG("fail to Call Function: " + _this)}]);
        _time = diag_tickTime - _time;
        LOG("Call: " + _x + " (" + str(_time*1000) +" ms)")
        nil
    } count _serverInit;
};

if (hasInterface) then {
    {
        private _time = diag_tickTime;
        _x call (missionNamespace getVariable [_x, {LOG("fail to Call Function: " + _this)}]);
        _time = diag_tickTime - _time;
        LOG("Call: " + _x + " (" + str(_time*1000) +" ms)")
        nil
    } count _clientInit;
};

if (!hasInterface && !isServer) then {
    {
        private _time = diag_tickTime;
        _x call (missionNamespace getVariable [_x, {LOG("fail to Call Function: " + _this)}]);
        _time = diag_tickTime - _time;
        LOG("Call: " + _x + " (" + str(_time*1000) +" ms)")
        nil
    } count _hcInit;
};

[{
    {
        private _time = diag_tickTime;
        _x call (missionNamespace getVariable [_x, {LOG("fail to Call Function: " + _this)}]);
        _time = diag_tickTime - _time;
        LOG("Call: " + _x + " (" + str(_time*1000) +" ms)")
        nil
    } count _this;

    [{
        [QGVAR(loadModules)] call bis_fnc_endLoadingScreen;
        disableUserInput false;
    }] call CFUNC(execNextFrame);

}, _postInit] call CFUNC(execNextFrame);

if (didJip) then {
    QGVAR(jipQueue) addPublicVariableEventHandler {
        {
            _x params ["_persistent", "_args", "_event"];
            if ((typeName _persistent) in ["STRING", "BOOL"]) then {
                if (_persistent isEqualType false && {_persistent}) then {
                    [_event, _args] call CFUNC(localEvent);
                } else {
                    if (_persistent isEqualTo (getPlayerUID CLib_Player)) then {
                        [_event, _args] call CFUNC(localEvent);
                    };
                };
            };
            nil
        } count (_this select 1);
    };
    ["loadJIPQueue", CLib_Player] call CFUNC(serverEvent);
};
