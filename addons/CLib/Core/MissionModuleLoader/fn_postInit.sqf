#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    load and Compile all Function from the Mission Modules

    Parameter(s):
    None

    Returns:
    None
*/

private _fnc_compileMissionFunction = {
    params [["_functionPath", "", [""]], ["_functionVarName", "", [""]]];
    #ifdef DEBUGFULL
        #define DEBUGHEADER "private _fnc_scriptMap = if (isNil '_fnc_scriptMap') then {[_fnc_scriptName]} else {_fnc_scriptMap + [_fnc_scriptName]};"
    #else
        #define DEBUGHEADER ""
    #endif

    #define SCRIPTHEADER "\
    private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {\
        '%1'\
    } else {\
        _fnc_scriptName\
    };\
    private _fnc_scriptName = '%1';\
    scriptName _fnc_scriptName;\
    scopeName (_fnc_scriptName + '_Main');\
    %2\
    "

    private _header = format [SCRIPTHEADER, _functionVarName, DEBUGHEADER];
    private _funcString = _header + preprocessFileLineNumbers _functionPath;

    private _fncCode = compile _funcString;

    {
        _x setVariable [_functionVarName, _fncCode];
        nil
    } count [missionNamespace, uiNamespace, parsingNamespace];
};

private _allMissionModules = [];

private _config = missionConfigFile >> "CfgClibMissionModules";

private _functionTag = getText (_config >> "tag");

// Read Module Loop
{
    private _moduleName = configName _x;
    DUMP("Read Mission Module: " + _moduleName)
    // Read Functions Loop
    {
        private _name = configName _x;
        private _fncName = format ["%1_%2_fnc_%3", _functionTag, _moduleName, _name];
        private _filePath = format ["CLibModules\%1\fn_%2.sqf", _moduleName, _name];
        DUMP("Read Mission Module: " + _moduleName)
        _allMissionModules pushBackUnique _fncName;
        [_filePath, _fncName] call _fnc_compileMissionFunction;
        nil
    } count configProperties [_x, "isClass _x", true];
    nil
} count configProperties [_config, "isClass _x", true];

private _init = [];
private _serverInit = [];
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
    };
    DUMP("Read Mission Function: " + _x)
    nil
} count _allMissionModules;

{
    if (_x select 1) then {
        {
            private _time = diag_tickTime;
            _x call (missionNamespace getVariable [_x, {LOG("fail to Call Function: " + _this)}]);
            _time = diag_tickTime - _time;
            LOG("Mission Module Call: " + _x + " (" + str (_time * 1000) + " ms)")
            nil
        } count (_x select 0);
    };
    nil
} count [[_init, true], [_serverInit, isServer], [_clientInit, hasInterface], [_hcInit, !hasInterface && !isServer]];
