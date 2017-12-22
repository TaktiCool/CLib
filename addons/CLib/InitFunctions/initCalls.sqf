/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: Karel Moricky, Killzone_Kid
    a3\functions_f\initFunctions.sqf

    Description:
    -

    Parameter(s):
    None

    Returns:
    None
*/

/******************************************************************************************************
    FINISH

    When functions are saved, following operations are executed:
    1. MissionNamespace shortcuts are created
    2. Functions with 'recompile' param set to 1 are recompiled
    3. Functions with 'preInit' param set to 1 are executed
    4. Multiplayer framework is initialized
    5. Modules are initialized (running their own scripts, functions just wait until those scripts are ready)
    6. Automatic scripts "initServer.sqf", "initPlayerServer.sqf" and "initPlayerLocal.sqf" are executed
    7. Functions with 'postInit' param set to 1 are executed

    When done, system will set 'BIS_fnc_init' to true so other systems can catch it.

******************************************************************************************************/

//--- Not core
if (_recompile in [0,1,3,4,5]) then {
    {
        _allowRecompile = (_x call (uiNamespace getVariable "BIS_fnc_functionMeta")) select 5;

        _xCode = uiNamespace getVariable _x;
        if (_allowRecompile || !_compileFinal) then {
            _xCode = call compile str (uiNamespace getVariable _x);
        };
        missionNamespace setVariable [_x, _xCode];
        nil;
    } count (_functions_list - _functions_listRecompile); //--- Exclude functions marker for recompile to avoid double-compile
};

//--- Core only
if (_recompile == 2) then {
    //--- Call preStart functions
    if (isnull (finddisplay 0)) then {
        {
            ["preStart %1",_x] call BIS_fnc_logFormat;
            _function = [] call (uiNamespace getVariable _x);
            uiNamespace setVariable [_x + "_preStart", _function];
            nil;
        } count _functions_listPreStart;
    };
};

//--- Mission only
if (_recompile in [3,5]) then {

    //--- Switch to mission loading bar
    RscDisplayLoading_progressMission = true;

    //--- Execute script preload
    [] call BIS_fnc_preload;

    //--- Create functions logic (cannot be created when game is launching; server only)
    if (isServer && isNull (missionNamespace getVariable ["BIS_functions_mainscope",objnull]) && !isNil {uiNamespace getVariable "BIS_fnc_init"} && worldname != "") then {
        private ["_grpLogic"];
        createcenter sidelogic;
        _grpLogic = creategroup sidelogic;
        BIS_functions_mainscope = _grpLogic createunit ["Logic",[9,9,9],[],0,"none"];
        BIS_functions_mainscope setVariable ["isDedicated",isDedicated,true];

        //--- Support for netId in SP (used in BIS_fnc_netId, BIS_fnc_objectFromNetId, BIS_fnc_groupFromNetId)
        //--- Format [netId1,grpOrObj1,netId2,grpOrObj2,...]
        if (!isMultiplayer) then {BIS_functions_mainscope setVariable ["BIS_fnc_netId_globIDs_SP", []]};

        publicVariable "BIS_functions_mainscope";
    };
    (group BIS_functions_mainscope) setgroupid [localize "str_dn_modules"]; //--- Name the group for curator

    if (!isNil "BIS_functions_mainscope") then {
        private ["_test", "_test2"];
        _test = BIS_functions_mainscope setPos (position BIS_functions_mainscope); if (isNil "_test") then {_test = false};
        _test2 = BIS_functions_mainscope playMove ""; if (isNil "_test2") then {_test2 = false};
        if (_test || _test2) then {0 call (compile (preprocessFileLineNumbers "a3\functions_f\misc\fn_initCounter.sqf"))};
    };

    //--- Recompile selected functions
    if (!is3DEN) then {
        _fnc_scriptname = "recompile";
        {
            ["recompile %1",_x] call BIS_fnc_logFormat;
            _x call BIS_fnc_recompile;
            nil;
        } count _functions_listRecompile;

        //--- Call preInit functions
        _fnc_scriptname = "preInit";
        {
            {
                _time = diag_tickTime;
                _x call {
                    private ["_recompile","_functions_list","_functions_listPreInit","_functions_listPostInit","_functions_listRecompile","_time"];
                    ["preInit"] call (missionNamespace getVariable _this)
                };
                ["%1 (%2 ms)",_x,(diag_tickTime - _time) * 1000] call BIS_fnc_logFormat;
                nil;
            } count _x;
            nil;
        } count _functions_listPreInit;
    };

    //--- Call postInit functions once player is present
    _functions_listPostInit spawn {
        _fnc_scriptName = "script";
        0.15 call BIS_fnc_progressloadingscreen;

        //--- Wait until server is initialized (to avoid running scripts before the server)
        waitUntil {call (missionNamespace getVariable ["BIS_fnc_preload_server",{isServer}]) || getClientState == "LOGGED IN"};
        if (getClientState == "LOGGED IN") exitwith {}; //--- Server lost
        0.30 call BIS_fnc_progressloadingscreen;

        //--- After JIP, units cannot be initialized during the loading screen
        if !(isServer) then {
            endLoadingScreen;
            waitUntil {!isnull cameraOn && {getClientState != "MISSION RECEIVED" && {getClientState != "GAME LOADED"}}};

            ["BIS_fnc_initFunctions"] call BIS_fnc_startLoadingScreen;
        };
        if (isNil "BIS_functions_mainscope") exitwith {endLoadingScreen; ["[x] Error while loading the mission!"] call BIS_fnc_errorMsg;}; //--- Error while loading
        BIS_functions_mainscope setVariable ["didJIP", didJIP];
        0.45 call BIS_fnc_progressloadingscreen;

        //wait for functions mainscope to get initialized (overruled by escape condition at line: 577)
        //waituntil {!isNil "BIS_functions_mainscope" && {!isnull BIS_functions_mainscope}};
        0.60 call BIS_fnc_progressloadingscreen;

        //--- Wait until module inits are initialized
        [] call BIS_fnc_initModules;
        0.75 call BIS_fnc_progressloadingscreen;

        //--- Execute automatic scripts
        if (!is3DEN) then {
            if (isServer) then {
                [] execVM "initServer.sqf";
                "initServer.sqf" call BIS_fnc_logFormat;
            };

            //--- Run mission scripts
            if !(isDedicated) then {
                [player,didJIP] execVM "initPlayerLocal.sqf";
                [[[player,didJIP],"initPlayerServer.sqf"],"BIS_fnc_execVM",false,false] call BIS_fnc_mp;
                "initPlayerLocal.sqf" call BIS_fnc_logFormat;
                "initPlayerServer.sqf" call BIS_fnc_logFormat;
            };
            0.90 call BIS_fnc_progressloadingscreen;

            //--- Call postInit functions
            _fnc_scriptname = "postInit";
            {
                {
                    _time = diag_tickTime;
                    [_x,didJIP] call {
                        params ["_data", "_didJip"];
                        private ["_time"];
                        ["postInit", _didJip] call (missionNamespace getVariable _data);
                    };
                    ["%1 (%2 ms)",_x,(diag_tickTime - _time) * 1000] call BIS_fnc_logFormat;
                    nil;
                } count _x;
                nil;
            } count _this;
            1.0 call BIS_fnc_progressloadingscreen;
        };

        //--- MissionNamespace init
        missionNamespace setVariable ["BIS_fnc_init",true];

        if !(isServer) then
        {
            ["BIS_fnc_initFunctions"] call BIS_fnc_endLoadingScreen;
        };
    };
};

//--- Not mission
if (_recompile in [0,1,2]) then {

    //--- UInameSpace init
    uiNamespace setVariable ["BIS_fnc_init",true]
};

//--- Only mission variables
if (_recompile in [4]) then {

    //--- MissionNameSpace init
    missionNamespace setVariable ["BIS_fnc_init",true];
};

//--- Only mission variables
if (_recompile in [1,5]) then {
    _fnc_scriptname = "initFunctions";
    "Functions recompiled" call BIS_fnc_log;
};
