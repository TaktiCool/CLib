/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: Karel Moricky, Killzone_Kid
    a3\functions_f\initFunctions.sqf

    Description:
    Function library initialization.

    Parameter(s):
    0: Function to compile with optional header type <String, Array>

    Returns:
    None
*/
#define SCRIPTNAME(var) private _fnc_scriptName = var
if (isNil "BIS_fnc_MP_packet") then {BIS_fnc_MP_packet = compileFinal ""}; //--- is not used anymore and so it should not be used anymore

//--- Fake header
private _fnc_scriptName = if (isNil "_fnc_scriptName") then {"Functions Init"} else {_fnc_scriptName};

/******************************************************************************************************
    DEFINE HEADERS

    Headers are pieces of code inserted on the beginning of every function code before compiling.
    Using 'BIS_fnc_functionsDebug', you can alter the headers to provide special debug output.

    Modes can be following:
    0: No Debug - header saves parent script name and current script name into variables
    1: Save script Map - header additionaly save an array of all parent scripts into variable
    2: Save and log script map - apart from saving into variable, script map is also logged through debugLog

    Some system function are using simplified header unaffected to current debug mode.
    These functions has headerType = 1; set in config.

******************************************************************************************************/

private _headerNoDebug = "
    private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'%1'} else {_fnc_scriptName};
    private _fnc_scriptName = '%1';
    scriptName _fnc_scriptName;
";
private _headerSaveScriptMap = "
    private _fnc_scriptMap = if (isNil '_fnc_scriptMap') then {[_fnc_scriptName]} else {_fnc_scriptMap + [_fnc_scriptName]};
";
private _headerLogScriptMap = "
    textLogFormat ['%1 : %2', _fnc_scriptMap joinString ' >> ', _this];
";
private _headerSystem = "
    private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'%1'} else {_fnc_scriptName};
    scriptName '%1';
";
private _headerNone = "";
private _debugHeaderExtended = "";

//--- Compose headers based on current debug mode
private _debug = uiNamespace getVariable ["BIS_fnc_initFunctions_debugMode",0];
private _headerDefault = switch _debug do {

    //--- 0 - Debug mode off
    default {
        _headerNoDebug
    };

    //--- 1 - Save script map (order of executed functions) to '_fnc_scriptMap' variable
    case 1: {
        _headerNoDebug + _headerSaveScriptMap
    };

    //--- 2 - Save script map and log it
    case 2: {
        _headerNoDebug + _headerSaveScriptMap + _headerLogScriptMap
    };
};


///////////////////////////////////////////////////////////////////////////////////////////////////////
//--- Compile function
private _fncCompile = {
    private ["_fncExt","_header","_debugMessage"];
    params  ["_fncVar","_fncMeta","_fncHeader", "_fncFinal"];
    _fncMeta params ["_fncPath", "_fncExt"];

    switch _fncExt do {
        //--- SQF
        case ".sqf": {
            _header = switch (_fncHeader) do {
                //--- No header (used in low-level functions, like 'fired' event handlers for every weapon)
                case -1: {
                    _headerNone
                };
                //--- System functions' header (rewrite default header based on debug mode)
                case 1: {
                    _headerSystem
                };
                //--- Full header
                default {
                    _headerDefault
                };
            };

            //--- Extend error report by including name of the function responsible
            _debugHeaderExtended = format ["%4%1line 1 ""%2 [%3]""%4", "#", _fncPath, _fncVar, toString [13,10]];
            _debugMessage = "Log: [Functions]%1 | %2";

            if (_fncFinal) then {
                compileFinal (format [_header, _fncVar, _debugMessage] + _debugHeaderExtended + preprocessFileLineNumbers _fncPath);
            } else {
                compile (format [_header, _fncVar, _debugMessage] + _debugHeaderExtended + preprocessFileLineNumbers _fncPath);
            };
        };

        //--- FSM
        case ".fsm": {
            compileFinal format ["%1_fsm = _this execfsm '%2'; %1_fsm", _fncVar, _fncPath];
        };

        default {0}
    };
};

//--- Compile only selected
if (isNil "_this") then {_this = [];};
if !(_this isEqualType []) then {_this = [_this];};
params [["_recompile", 0]];

/******************************************************************************************************
    COMPILE ONE FUNCTION

    When input is string containing function name instead of number, only the function is recompiled.

    The script stops here, reads function's meta data and recompile the function
    based on its extension and header.

    Instead of creating missionNamespace shortcut, it saves the function directly. Use it only for debugging!

******************************************************************************************************/

if (_recompile isEqualType "") exitwith {

    //--- Recompile specific function
    private _fnc_uiNamespace = true;
    private _fnc = uiNamespace getVariable _recompile;
    if (isNil "_fnc") then {_fnc = missionNamespace getVariable _recompile; _fnc_uiNamespace = false;};
    if !(isNil "_fnc") then {
        private _fncMeta = _recompile call (uiNamespace getVariable "BIS_fnc_functionMeta");
        private _headerType = if (count _this > 1) then {_this select 1} else {0};
        private _var = [_recompile, [_recompile, _fncMeta, _headerType, false] call _fncCompile];
        if (cheatsEnabled && {_fnc_uiNamespace}) then {uiNamespace setVariable _var;}; //--- Cannot recompile compileFinal functions in public version
        missionNamespace setVariable _var;
        if (isNil "_functions_listRecompile") then {
            textLogFormat ["Log: [Functions]: %1 recompiled with meta %2",_recompile,_fncMeta];
        };
    } else {
        private _fncError = uiNamespace getVariable "BIS_fnc_error";
        if !(isNil "_fncError") then {
            ["%1 is not a function.",_recompile] call _fncError;
        } else {
            textLogFormat ["Log: [Functions]: ERROR: %1 is not a function.",_recompile];
        };
    };
};


/******************************************************************************************************
    COMPILE EVERYTHING IN GIVEN NAMESPACE(S)

    Function codes are present only in uiNamespace. Mission variables contains only shortcuts to uiNamespace.
    To executed only required compilation section, input param can be one of following numbers:

    0 - Autodetect what compile type should be used
    1 - Forced recompile of all the things
    2 - Create only uiNamespace variables (used in UI)
    3 - Create missionNamespace variables and initialize mission
    4 - Create only missionNamespace variables
    5 - Recompile all functions, and initialize mission (used for editor preview with function recompile)

******************************************************************************************************/

RscDisplayLoading_progressMission = nil;

//--- Get existing lists (create new ones when they doesn't exist)

private _functions_listPreStart = [];
private _functions_list = call (uiNamespace getVariable ["BIS_functions_list",{[]}]);
private _functions_listPreInit = [call (uiNamespace getVariable ["BIS_functions_listPreInit",{[]}]),[]];
private _functions_listPostInit = [call (uiNamespace getVariable ["BIS_functions_listPostInit",{[]}]),[]];

private _functions_listRecompile = call (uiNamespace getVariable ["BIS_functions_listRecompile",{[]}]);

//--- When not forced, recompile only mission if uiNamespace functions exists
if !(_recompile isEqualType 1) then {
    _recompile = if (count _functions_list > 0) then {3} else {0};
};

//--- When autodetect, recognize what recompile type is required
if (_recompile == 0 && !isNil {uiNamespace getVariable "BIS_fnc_init"}) then {_recompile = 3;};
if (_recompile == 3 && !isNil {missionNamespace getVariable "BIS_fnc_init"}) then {_recompile = 4;};
if (_recompile == 3 && !is3DEN && ("Preferences" get3DENMissionAttribute "RecompileFunctions")) then {_recompile = 5;};

private _file = getText (configfile >> "cfgFunctions" >> "file");
private _cfgSettings = [
    [    configfile,        _file,        0    ],    //--- 0
    [    campaignconfigfile,    "functions",    1    ],    //--- 1
    [    missionconfigfile,    "functions",    1    ]    //--- 2
];

private _listConfigs = switch _recompile do {
    case 0: {
        [0,1,2];
    };
    case 5;
    case 1: {
        _functions_list = [];
        uiNamespace setVariable ["BIS_functions_list",_functions_list];
        _functions_listPreInit = [[],[]];
        uiNamespace setVariable ["BIS_functions_listPreInit",_functions_listPreInit];
        _functions_listPostInit = [[],[]];
        uiNamespace setVariable ["BIS_functions_listPostInit",_functions_listPostInit];
        _functions_listRecompile = [];
        uiNamespace setVariable ["BIS_functions_listRecompile",_functions_listRecompile];
        [0,1,2];
    };
    case 2: {
        [0];
    };
    case 3: {
        [1,2];
    };
    case 4: {
        [1,2];
    };
};


/******************************************************************************************************
    SCAN CFGFUNCTIONS

    Go through CfgFunctions, scan categories and declare all functions.

    Following variables are stored:
    <tag>_fnc_<functionName> - actual code of the function
    <tag>_fnc_<functionName>_meta - additional meta data of this format
        [<path>,<extension>,<header>,<preInit>,<postInit>,<recompile>,<category>]
        * path - path to actual file
        * extension - file extension, either ".sqf" or ".fsm"
        * header - header type. Usually 0, system functions are using 1 (see DEFINE HEADERS section)
        * preInit - function is executed automatically upon mission start, before objects are initalized
        * postInit - function is executed automatically upon mission start, after objects are initialized
        * recompile - function is recompiled upon mission start
        * category - function's category based on config structure

******************************************************************************************************/

//--- Allow recompile in dev version, in the editor and when description.ext contains 'allowFunctionsRecompile = 1;'
private _compileFinal =
//--- Dev version
!cheatsEnabled
//--- Editor mission
 && ((uiNamespace getVariable ["gui_displays",[]]) find (finddisplay 26) != 1)
//--- Manual toggle
 && getNumber (missionconfigfile >> "allowFunctionsRecompile") == 0;

{
    private _cfg = _cfgSettings select _x;
    _cfg params ["_pathConfig", "_pathFile", "_pathAccess"];

    {
        private _currentTag = _x;
        //--- Is Tag
        //--- Check of all required patches are in CfgPatches
        private ["_requiredAddons","_requiredAddonsMet"];
        private _requiredAddons = getArray (_currentTag >> "requiredAddons");
        _requiredAddonsMet = true;
        {
            _requiredAddonsMet = _requiredAddonsMet && isClass (configfile >> "CfgPatches" >> _x);
            if (_requiredAddonsMet) exitWith {};
            nil;
        } count _requiredAddons;

        if (_requiredAddonsMet) then {

            //--- Initialize tag
            private _tag = configName _currentTag;
            private _tagName = getText (_currentTag >> "tag");
            if (_tagName == "") then {_tagName = _tag};
            private _itemPathTag = getText (_currentTag >> "file");

            {
                private _currentCategory = _x;

                //--- Is Category
                private _categoryName = configName _currentCategory;
                private _itemPathCat = getText (_currentCategory >> "file");

                {
                    private _currentItem = _x;

                    //--- Is Item
                    if (isClass _currentItem) then {
                        // private ["_itemVar","_itemCompile","_itemPreInit","_itemPostInit","_itemPreStart","_itemRecompile","_itemCheatsEnabled"];

                        //--- Read function
                        private _itemName = configName _currentItem;
                        private _itemPathItem = getText (_currentItem >> "file");
                        private _itemExt = getText (_currentItem >> "ext");
                        private _itemPreInit = getNumber (_currentItem >> "preInit");
                        private _itemPostInit = getNumber (_currentItem >> "postInit");
                        private _itemUnscheudled = getNumber (_currentItem >> "unscheudled");
                        private _itemPreStart = getNumber (_currentItem >> "preStart");
                        private _itemRecompile = getNumber (_currentItem >> "recompile");
                        private _itemCheatsEnabled = getNumber (_currentItem >> "cheatsEnabled");
                        if (_itemExt == "") then {_itemExt = ".sqf"};
                        private _itemPath = if (_itemPathItem != "") then {
                            if (_tagName == "BIS" && _pathAccess == 0) then {
                                //--- Disable rewriting of global BIS functions from outside (ToDo: Make it dynamic, so anyone can protect their functions)
                                private _itemPathItemA3 = (tolower _itemPathItem) find "a3";
                                private _itemPathSlash = (tolower _itemPathItem) find "\";
                                if ((_itemPathItemA3 < 0 || _itemPathItemA3 > 1) && _itemPathSlash > 0) then {_itemPathItem = "";};
                            };
                            _itemPathItem
                        } else {
                            ""
                        };
                        if (_itemPath == "") then {
                            _itemPath = if (_itemPathCat != "") then {_itemPathCat + "\fn_" + _itemName + _itemExt} else {
                                if (_itemPathTag != "") then {_itemPathTag + "\fn_" + _itemName + _itemExt} else {""};
                            };
                        };
                        private _itemHeader = getNumber (_currentItem >> "headerType");

                        //--- Compile function
                        if (_itemPath == "") then {_itemPath = _pathFile + "\" + _categoryName + "\fn_" + _itemName + _itemExt};
                        private _itemVar = _tagName + "_fnc_" + _itemName;
                        private _itemMeta = [_itemPath, _itemExt, _itemHeader, _itemPreInit > 0, _itemPostInit > 0, _itemRecompile> 0, _tag, _categoryName, _itemName, _itemUnscheudled> 0];
                        private _itemCompile = if (_itemCheatsEnabled == 0 || (_itemCheatsEnabled > 0 && cheatsEnabled)) then {
                            [_itemVar, _itemMeta, _itemHeader, _compileFinal] call _fncCompile;
                        } else {
                            compilefinal "false" //--- Function not available in retail version
                        };

                        //--- Register function
                        if (_itemCompile isEqualType {}) then {
                            if !(_itemVar in _functions_list) then {
                                private _namespaces = if (_pathAccess == 0) then {[uiNamespace, missionNamespace]} else {[missionNamespace]};
                                {
                                    //---- Save function
                                    _x setVariable [
                                        _itemVar,
                                        _itemCompile
                                    ];
                                    //--- Save function meta data
                                    _x setVariable [
                                        _itemVar + "_meta",
                                        compileFinal str _itemMeta
                                    ];
                                    nil;
                                } count _namespaces;
                                if (_pathAccess == 0) then {
                                    _functions_list pushBack _itemVar;
                                    nil;
                                };
                            };

                            //--- Add to list of functions executed upon mission start
                            if (_itemPreInit > 0) then {
                                private _functions_listPreInitAccess = _functions_listPreInit select _pathAccess;
                                if !(_itemVar in _functions_listPreInitAccess) then {
                                    _functions_listPreInitAccess pushBack _itemVar;
                                };
                            };
                            if (_itemPostInit > 0) then {
                                private _functions_listPostInitAccess = _functions_listPostInit select _pathAccess;
                                if !(_itemVar in _functions_listPostInitAccess) then {
                                    _functions_listPostInitAccess pushBack _itemVar;
                                    nil;
                                };
                            };

                            //--- Add to list of functions executed upon game start
                            if (_itemPreStart > 0) then {
                                if (_pathAccess == 0) then {
                                    if !(_itemVar in _functions_listPreStart) then {
                                        _functions_listPreStart pushBack _itemVar;
                                        nil;
                                    };
                                } else {
                                    private _errorFnc = uiNamespace getVariable "BIS_fnc_error";
                                    private _errorText = "%1 is a mission / campaign function and cannot contain 'preStart = 1;' param";
                                    if (isNil "_errorFnc") then {
                                        diag_log format ["Log: [Functions]: " + _errorText,_itemVar];
                                    } else {
                                        [_errorText, _itemVar] call _errorFnc;
                                    };
                                };
                            };

                            //--- Add to list of functions recompiled upon mission start
                            if (_itemRecompile > 0) then {
                                if (_pathAccess == 0) then {
                                    if !(_itemVar in _functions_listRecompile) then {
                                        _functions_listRecompile pushBack _itemVar;
                                    };
                                } else {
                                    private _errorFnc = uiNamespace getVariable "BIS_fnc_error";
                                    private _errorText = "Redundant use of 'recompile = 1;' in %1 - mission / campaign functions are recompiled on start by default.";
                                    if (isNil "_errorFnc") then  {
                                        diag_log format ["Log: [Functions]: " + _errorText,_itemVar];
                                    } else {
                                        [_errorText,_itemVar] call _errorFnc;
                                    };
                                };
                            };

                            //if (_itemRecompile > 0) then {
                            //    _functions_listRecompileAccess = _functions_listRecompile select _pathAccess;
                            //    _functions_listRecompileAccess set [count _functions_listRecompileAccess,_itemVar];
                            //};
                            //--- Debug
                            //debuglog ["Log:::::::::::::::::::Function",_itemVar,_itemPath,_pathAccess];
                        };
                    };

                    nil;
                } count ("isClass _x" configClasses _currentCategory);
                nil;
            } count ("isClass _x" configClasses _currentTag);
        };
        nil;
    } count ("isClass _x" configClasses (_pathConfig >> "cfgFunctions"));
    nil;
} count _listConfigs;
nil;
//--- Save the lists (only when they're undefined, or in dev version where compileFinal variables can be rewritten)
if (isNil {uiNamespace getVariable "BIS_functions_list"} || {cheatsEnabled}) then {
    uiNamespace setVariable ["BIS_functions_list", compileFinal str (_functions_list)];
    uiNamespace setVariable ["BIS_functions_listPreInit", compileFinal str (_functions_listPreInit select 0)];
    uiNamespace setVariable ["BIS_functions_listPostInit", compileFinal str (_functions_listPostInit select 0)];
    uiNamespace setVariable ["BIS_functions_listRecompile", compileFinal str (_functions_listRecompile)];
};

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
        private _allowRecompile = (_x call (uiNamespace getVariable "BIS_fnc_functionMeta")) select 5;

        private _xCode = uiNamespace getVariable _x;
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
            private _function = [] call (uiNamespace getVariable _x);
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
                private _time = diag_tickTime;
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
        SCRIPTNAME("script");
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
            SCRIPTNAME("postInit");
            {
                {
                    private _time = diag_tickTime;
                    private _unscheudled = (missionNamespace getVariable _x + "_meta") select 9;
                    [_x, didJIP, _unscheudled] call {
                        params ["_data", "_didJip", "_unscheudled"];
                        private ["_time"];
                        if (_unscheudled) then {
                            isNil {
                                ["postInit", _didJip] call (missionNamespace getVariable _data);
                            };
                        } else {
                            ["postInit", _didJip] call (missionNamespace getVariable _data);
                        };
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


//--- Log the info about selected recompile type
/*
_recompileNames = [
    "ERROR: Autodetect failed",
    "Forced",
    "Core Only",
    "Mission/Campaign Only"
];
*/
//["Initialized: %1.",_recompileNames select _recompile] call (uiNamespace getVariable "BIS_fnc_logFormat");
