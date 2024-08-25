#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Loads and compiles all functions from the Client Addon modules

    Parameter(s):
    None

    Returns:
    None
*/

private _fnc_compileClientFunction = {
    params [["_functionPath", "", [""]], ["_functionVarName", "", [""]]];
    #ifdef DEBUGFULL
        #define DEBUGHEADER "private _fnc_scriptMap = if (isNil '_fnc_scriptMap') then {[_fnc_scriptName]} else {_fnc_scriptMap + [_fnc_scriptName]};"
    #else
        #define DEBUGHEADER ""
    #endif

    #define SCRIPTHEADER "private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'%1'} else {_fnc_scriptName};private _fnc_scriptName = '%1';scriptName _fnc_scriptName;scopeName (_fnc_scriptName + '_Main');%2"

    private _header = format [SCRIPTHEADER, _functionVarName, DEBUGHEADER];
    private _funcString = _header + preprocessFileLineNumbers _functionPath;

    private _fncCode = compile _funcString;

    {
        _x setVariable [_functionVarName, _fncCode];
    } forEach [missionNamespace, uiNamespace, parsingNamespace];
};

private _allClientModules = [];

private _config = configFile >> "CfgCLibAddonModules";
if !(isClass _config) exitWith {};
private _functionTag = getText (_config >> "tag");

// Read Module Loop
{
    private _moduleName = configName _x;
    private _path = getText (_x >> "path");
    DUMP("Read Client Addon Module: " + _moduleName);
    // Read Functions Loop
    {
        private _name = configName _x;
        private _fncName = format ["%1_%2_fnc_%3", _functionTag, _moduleName, _name];
        private _filePath = format ["\%1\%2\fn_%3.sqf", _path, _moduleName, _name];
        DUMP("Read Client Addon Module: " + _moduleName);
        _allClientModules pushBackUnique _fncName;
        [_filePath, _fncName] call _fnc_compileClientFunction;
    } forEach configProperties [_x, "isClass _x", true];
} forEach configProperties [_config, "isClass _x", true];

private _init = [];
private _serverInit = [];
private _clientInit = [];
private _hcInit = [];

// Cycle through all available functions and determine whether to call them or not.
{
    call {
        private _name = toLowerANSI _x;
        // Client only functions.
        if ("_fnc_clientinit" in _name) exitWith {
            _clientInit pushBack _x;
        };
        // Server only functions.
        if ("_fnc_serverinit" in _name) exitWith {
            _serverInit pushBack _x;
        };
        // HC only functions.
        if ("_fnc_hcinit" in _name) exitWith {
            _hcInit pushBack _x;
        };
        // Functions for both.
        if ("_fnc_init" in _name) exitWith {
            _init pushBack _x;
        };
    };
    DUMP("Read Client Addon Function: " + _x);
} forEach _allClientModules;

{
    if (_x select 1) then {
        {
            private _time = diag_tickTime;
            _x call (missionNamespace getVariable [_x, {LOG("fail to Call Function: " + _this)}]);
            _time = diag_tickTime - _time;
            private _strTime = (_time * 1000) call CFUNC(toFixedNumber);
            LOG("Client Addon Module Call: " + _x + " (" + _strTime + " ms)");
        } forEach (_x select 0);
    };
} forEach [[_init, true], [_serverInit, isServer], [_clientInit, hasInterface], [_hcInit, !hasInterface && !isServer]];
