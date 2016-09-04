
diag_log ("Call Functions: " + str(diag_tickTime));
diag_log ("Recompile: " + str(_recompile));
//--- Not core
if (_recompile in [0,1,3,4]) then {
    {
        private _allowRecompile = (_x call (uiNamespace getVariable "bis_fnc_functionMeta")) select 5;

        private _xCode = uiNamespace getVariable _x;
        if (_allowRecompile || !_compileFinal) then {
            _xCode = call compile str (uiNamespace getVariable _x);
        };
        missionNamespace setVariable [_x, _xCode];
        nil
    } count _functions_list;
};

//--- Core only
if (_recompile == 2) then {
    //--- Call preStart functions
    if (isNull (finddisplay 0)) then {
        {
            ["preStart %1",_x] call bis_fnc_logFormat;
            _function = [] call (uiNamespace getVariable _x);
            uiNamespace setVariable [_x + "_preStart", _function];
            nil
        } count _functions_listPreStart;
    };
};

//--- Mission only
if (_recompile == 3) then {

    //--- Switch to mission loading bar
    RscDisplayLoading_progressMission = true;

    //--- Execute script preload
    [] call BIS_fnc_preLoad;

    //--- Create functions logic (cannot be created when game is launching; server only)
    if (isServer && isNull (missionNamespace getVariable ["bis_functions_mainscope",objNull]) && !isNil {uiNamespace getVariable "bis_fnc_init"} && worldname != "") then {
        private ["_grpLogic"];
        createcenter sidelogic;
        _grpLogic = creategroup sidelogic;
        bis_functions_mainscope = _grpLogic createunit ["Logic",[9,9,9],[],0,"none"];
        bis_functions_mainscope setVariable ["isDedicated", isDedicated, true];
        publicvariable "bis_functions_mainscope";
    };
    (group bis_functions_mainscope) setGroupID [localize "str_dn_modules"]; //--- Name the group for curator

    if (!isNil "bis_functions_mainscope") then {
        private ["_test", "_test2"];
        _test = bis_functions_mainscope setPos (position bis_functions_mainscope);
        _test2 = bis_functions_mainscope playMove "";
        if (isNil "_test") then {_test = false};
        if (isNil "_test2") then {_test2 = false};
        if (_test || _test2) then {0 call (compile (preprocessFileLineNumbers "a3\functions_f\misc\fn_initCounter.sqf"))};
    };

    //--- Recompile selected functions
    if ((count (supportInfo "n:is3DEN") > 0 && {!is3DEN}) || (count (supportInfo "n:is3DEN") == 0)) then {
        _fnc_scriptname = "recompile";
        {
            ["recompile %1",_x] call bis_fnc_logFormat;
            _x call bis_fnc_recompile;
            nil
        } count _functions_listRecompile;

        //--- Call preInit functions
        _fnc_scriptname = "preInit";
        {
            {
                _time = diag_ticktime;
                [_x] call {
                    ["preInit"] call (missionNamespace getVariable (_this select 0))
                };
                ["%1 (%2 ms)",_x,(diag_ticktime - _time) * 1000] call bis_fnc_logFormat;
                nil
            } count _x;
            nil
        } count _functions_listPreInit;
    };

    //--- Call postInit functions once player is present
    _functions_listPostInit spawn {     // Fuck that spawn need to find a better Method
        _fnc_scriptName = "script";
        0.10 call bis_fnc_progressloadingscreen;

        //--- Wait until server is initialized (to avoid running scripts before the server)
        waituntil {call (missionNamespace getVariable ["BIS_fnc_preload_server",{isServer}]) || getClientState == "LOGGED IN"};
        if (getClientState == "LOGGED IN") exitwith {}; //--- Server lost
        0.20 call bis_fnc_progressloadingscreen;

        //--- After JIP, units cannot be initialized during the loading screen
        if !(isServer) then {
            endLoadingScreen;
            waitUntil{!isNull cameraOn && {getClientState != "MISSION RECEIVED" && {getClientState != "GAME LOADED"}}};

            ["bis_fnc_initFunctions"] call bis_fnc_startLoadingScreen;
        };

        if (isNil "bis_functions_mainscope") exitwith { //--- Error while loading
            endLoadingScreen;
            ["[x] Error while loading the mission!"] call bis_fnc_errorMsg;
        };
        bis_functions_mainscope setVariable ["didJIP", didJIP];
        0.50 call bis_fnc_progressloadingscreen;

        //--- Wait until module inits are initialized
        [] call bis_fnc_initModules;
        0.60 call bis_fnc_progressloadingscreen;

        //--- Execute automatic scripts
        if ((count (supportInfo "n:is3DEN") > 0 && {!is3DEN}) || (count (supportInfo "n:is3DEN") == 0)) then {
            if (isServer) then {
                [] call compile preprocessFileLineNumbers "initServer.sqf";
                "initServer.sqf" call bis_fnc_logFormat;
            };

            //--- Run mission scripts
            if !(isDedicated) then {
                [player,didJIP] call compile preprocessFileLineNumbers "initPlayerLocal.sqf";
                [[[player,didJIP],"initPlayerServer.sqf"], "bis_fnc_execvm",false,false] call bis_fnc_mp;
                "initPlayerLocal.sqf" call bis_fnc_logFormat;
                "initPlayerServer.sqf" call bis_fnc_logFormat;
            };
            0.70 call bis_fnc_progressloadingscreen;

            //--- Call postInit functions
            _fnc_scriptname = "postInit";
            {
                {
                    _time = diag_ticktime;
                    [_x,didJIP] call {
                        ["postInit", _this select 1] call (missionNamespace getVariable (_this select 0))
                    };
                    ["%1 (%2 ms)",_x,(diag_ticktime - _time) * 1000] call bis_fnc_logFormat;
                    nil
                } count _x;
                nil
            } count _this;
            1.0 call bis_fnc_progressloadingscreen;
        };

        //--- MissionNamespace init
        missionNamespace setVariable ["bis_fnc_init",true];

        if !(isServer) then {
            ["bis_fnc_initFunctions"] call bis_fnc_endLoadingScreen;
        };
    };
};
diag_log ("Call Functions: Done " + str(diag_tickTime));
