#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Calls all init functions of all required modules for server and client. This should be called after modules are loaded and functions transferred.

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

private _thread = 0 spawn {
    scopeName "LoadingScreenFailCheck";
    private _time = time + 6;
    while {isNil QGVAR(AutoLoad_loadingScreenDone)} do {
        if (_time <= time) then {
            [QCGVAR(loadModules)] call BIS_fnc_endLoadingScreen;
            disableUserInput false;
            waitUntil {UIsleep 1; missionnamespace getvariable ["BIS_fnc_startLoadingScreen_ids",[]] isEqualTo []};
            private _errorText = "Warning A Script Error that Crashed Autoload has appeared the Loading Screen got Terminated Automaticly!";
            [
                _errorText,
                "ERROR: A Script Error happend"
            ] spawn BIS_fnc_guiMessage;
            LOG("ERROR: " + _errorText);
            breakOut "LoadingScreenFailCheck";
        };
        UIsleep 1;
    };
};

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
    DUMP("Read requiredFunctions: " + _x);
    nil
} count GVAR(requiredFunctions);

{
    if (_x select 1) then {
        {
            private _time = diag_tickTime;
            _x call (missionNamespace getVariable [_x, {LOG("fail to Call Function: " + _this)}]);
            _time = diag_tickTime - _time;
            private _strTime = (_time*1000) call CFUNC(toFixedNumber);
            LOG("Addon Module Call: " + _x + " (" + _strTime + " ms)");
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
        private _strTime = (_time*1000) call CFUNC(toFixedNumber);
        LOG("Addon Module Call: " + _x + " (" + _strTime + " ms)");

        nil
    } count (_this select 0);

    [{
        [QCGVAR(loadModules)] call BIS_fnc_endLoadingScreen;
        GVAR(AutoLoad_loadingScreenDone) = true;
        disableUserInput false;
        terminate _this;
        CGVAR(loadingIsFinished) = true;
        {
            (_x select 1) call (_x select 0);
            nil
        } count CGVAR(entryPointQueue);
    }, _this select 1] call CFUNC(execNextFrame);

}, [_postInit, _thread]] call CFUNC(execNextFrame);


if (didJIP) then {
    QGVAR(jipQueue) addPublicVariableEventHandler {
        {
            _x params [
                ["_persistent", false, ["", true]],
                ["_args", [], []],
                ["_event", "EventError", [""]]
            ];
            if (_persistent isEqualType true && {_persistent}) then {
                [_event, _args] call CFUNC(localEvent);
            } else {
                if (_persistent isEqualTo (getPlayerUID CLib_Player)) then {
                    [_event, _args] call CFUNC(localEvent);
                };
            };
            nil
        } count (_this select 1);
    };
    ["loadJIPQueue", CLib_Player] call CFUNC(serverEvent);
};
