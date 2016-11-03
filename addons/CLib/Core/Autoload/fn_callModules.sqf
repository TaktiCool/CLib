#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Calls all init functions of all required modules for server and client. This should be called after modules are loaded (functions transferred).

    Parameter(s):
    None

    Returns:
    None

    Example:
    call CFUNC(callModules);
*/
private _init = [];
private _serverInit = [];
private _postInit = [];
private _clientInit = [];
private _hcInit = [];

// Cycle through all available functions and determine whether to call them or not.
{
    call {
        private _name = toLower _x;
        // Client only functions.
        if (_name find "_fnc_clientinit" > 0) exitWith {
            _clientInit pushBack _x;
        };
        // Server only functions.
        if (_name find "_fnc_serverinit" > 0) exitWith {
            _serverInit pushBack _x;
        };
        // HC only functions.
        if (_name find "_fnc_hcinit" > 0) exitWith {
            _hcInit pushBack _x;
        };
        // Functions for both.
        if (_name find "_fnc_init" > 0) exitWith {
            _init pushBack _x;
        };
        if (_name find "_fnc_postinit" > 0) exitWith {
            _postInit pushBack _x;
        };
    };
    DUMP("Read requiredFunctions: " + _x)
    nil
} count GVAR(requiredFunctions);

{
    if (_x select 1) then {
        {
            private _time = diag_tickTime;
            _x call (missionNamespace getVariable [_x, {LOG("fail to Call Function: " + _this)}]);
            _time = diag_tickTime - _time;
            LOG("Server Module Call: " + _x + " (" + str(_time*1000) +" ms)")
            nil
        } count (_x select 0);
    };
    nil
} count [[_init, true], [_serverInit, isServer], [_clientInit, hasInterface], [_hcInit, !hasInterface && !isServer]];

[{
    {
        private _time = diag_tickTime;
        _x call (missionNamespace getVariable [_x, {LOG("fail to Call Function: " + _this)}]);
        _time = diag_tickTime - _time;
        LOG("Server Module Call: " + _x + " (" + str(_time*1000) +" ms)")
        nil
    } count _this;

    [{
        [QCGVAR(loadModules)] call bis_fnc_endLoadingScreen;
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
