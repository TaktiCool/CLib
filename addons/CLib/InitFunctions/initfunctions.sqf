
/*
    File: init.sqf
    Author: Karel Moricky, optimised headers by Killzone_Kid

    Description:
    Function library initialization.

    Parameter(s):
    _this select 0: 'Function manager' logic

    Returns:
    Nothing
*/

#define VERSION    3.0
diag_log ("initFunctions.sqf Loaded: " + str(diag_tickTime));
//--- Fake header
private _fnc_scriptName = if (isNil "_fnc_scriptName") then {"Functions Init"} else {_fnc_scriptName};

//--- Check version, has to match config version
if (getNumber (configfile >> "CfgFunctions" >> "Version") != VERSION) exitwith {
    // Save exit if version Number is Not Equal use BI version
    call compile preprocessFileLineNumbers "A3\functions_f\initFunctions.sqf";
};

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

private "_this";

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

//--- Compose headers based on current debug mode
private _debug = uiNamespace getVariable ["bis_fnc_initFunctions_debugMode",0];
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
    private ["_header","_debugMessage"];
    params ["_fncVar", "_fncMeta", "_fncHeader", "_fncFinal"];

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
                }
            };
            _debugMessage = "Log: [Functions]%1 | %2";
            if (_fncFinal) then {
                compileFinal (format [_header,_fncVar,_debugMessage] + preprocessfilelinenumbers _fncPath);
            } else {
                compile (format [_header,_fncVar,_debugMessage] + preprocessfilelinenumbers _fncPath);
            };
        };

        //--- FSM
        case ".fsm": {
            compileFinal format ["%1_fsm = _this execfsm '%2'; %1_fsm",_fncVar,_fncPath];
        };

        default {0}
    };
};


/******************************************************************************************************
    COMPILE ONE FUNCTION

    When input is string containing function name instead of number, only the function is recompiled.

    The script stops here, reads function's meta data and recompile the function
    based on its extension and header.

    Instead of creating missionNamespace shortcut, it saves the function directly. Use it only for debugging!

******************************************************************************************************/

//--- Compile only selected
if (isNil "_this") then {_this = [];};
if !(_this isEqualType []) then {_this = [_this];};
private _recompile = if (count _this > 0) then {_this select 0} else {0};

if (_recompile isEqualType "") exitwith {

    //--- Recompile specific function
    private _fncuiNamespace = true;
    private _fnc = uiNamespace getVariable _recompile;
    if (isNil "_fnc") then {
        _fnc = missionNamespace getVariable _recompile;
        _fncuiNamespace = false;
    };
    if !(isNil "_fnc") then {
        private _fncMeta = _recompile call (uiNamespace getVariable "bis_fnc_functionMeta");
        private _headerType = if (count _this > 1) then {_this select 1} else {0};
        private _var = [_recompile,[_recompile,_fncMeta,_headerType,false] call _fncCompile];
        if (_fncuiNamespace) then {uiNamespace setVariable _var;};
        missionNamespace setVariable _var;
        if (isNil "_functions_listRecompile") then {
            textlogformat ["Log: [Functions]: %1 recompiled with meta %2",_recompile,_fncMeta];
        };
    } else {
        private _fncError = uiNamespace getVariable "bis_fnc_error";
        if !(isNil "_fncError") then {
            ["%1 is not a function.",_recompile] call _fncError;
        } else {
            textlogformat ["Log: [Functions]: ERROR: %1 is not a function.",_recompile];
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

******************************************************************************************************/

RscDisplayLoading_progressMission = nil;

//--- Get existing lists (create new ones when they doesn't exist)
private _functions_listPreStart = [];
private _functions_list = call (uiNamespace getVariable ["bis_functions_list",{[]}]);
private _functions_listPreInit = [call (uiNamespace getVariable ["bis_functions_listPreInit",{[]}]),[]];
private _functions_listPostInit = [call (uiNamespace getVariable ["bis_functions_listPostInit",{[]}]),[]];
private _functions_listRecompile = call (uiNamespace getVariable ["bis_functions_listRecompile",{[]}]);

//--- When not forced, recompile only mission if uiNamespace functions exists
if !(_recompile isEqualType 1) then {
    _recompile = if (count _functions_list > 0) then {3} else {0};
};

//--- When autodetect, recognize what recompile type is required
if (_recompile == 0 && !isNil {uiNamespace getVariable "bis_fnc_init"}) then {_recompile = 3;};
if (_recompile == 3 && !isNil {missionNamespace getVariable "bis_fnc_init"}) then {_recompile = 4;};

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
    case 1: {
        _functions_list = [];
        uiNamespace setVariable ["bis_functions_list",_functions_list];
        _functions_listPreInit = [[],[]];
        uiNamespace setVariable ["bis_functions_listPreInit",_functions_listPreInit];
        _functions_listPostInit = [[],[]];
        uiNamespace setVariable ["bis_functions_listPostInit",_functions_listPostInit];
        _functions_listRecompile = [];
        uiNamespace setVariable ["bis_functions_listRecompile",_functions_listRecompile];
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
    &&
    //--- Editor mission
    ((uiNamespace getVariable ["gui_displays",[]]) find (finddisplay 26) != 1)
    &&
    //--- Manual toggle
    getNumber (missionconfigfile >> "allowFunctionsRecompile") == 0;

{
    private _cfg = _cfgSettings select _x;
    _cfg params ["_pathConfig", "_pathFile", "_pathAccess"];
    private _cfgFunctions = (_pathConfig >> "cfgfunctions");
    {
        private _currentTag = _x;

        //--- Check of all required patches are in CfgPatches
        private _requiredAddons = getArray (_currentTag >> "requiredAddons");
        private _requiredAddonsMet = true;
        {
            if !(isClass (configfile >> "CfgPatches" >> _x)) exitWith {
                _requiredAddonsMet = false;
            };
            nil
        } count _requiredAddons;

        if (_requiredAddonsMet) then {

            //--- Initialize tag
            private _tag = configName _currentTag;
            private _tagName = getText (_currentTag >> "tag");
            if (_tagName == "") then {_tagName = configName _currentTag};
            _itemPathTag = getText (_currentTag >> "file");

            {

                private _currentCategory = _x;
                private _categoryName = configName _currentCategory;
                private _itemPathCat = getText (_currentCategory >> "file");

                {
                    // extern File to keep the file more clean
                    #include "compileLoop.sqf";
                    nil
                } count (configProperties [_currentCategory,"isClass _x"]);
                nil
            } count (configProperties [_currentTag,"isClass _x"]);
        };
        nil
    } count (configProperties [_cfgFunctions,"isClass _x"]);
    nil
} count _listConfigs;

//--- Save the lists
uiNamespace setVariable ["BIS_functions_list",compileFinal str (_functions_list)];
uiNamespace setVariable ["BIS_functions_listPreInit",compileFinal str (_functions_listPreInit select 0)];
uiNamespace setVariable ["BIS_functions_listPostInit",compileFinal str (_functions_listPostInit select 0)];
uiNamespace setVariable ["BIS_functions_listRecompile",compileFinal str (_functions_listRecompile)];


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

    When done, system will set 'bis_fnc_init' to true so other systems can catch it.

******************************************************************************************************/

#include "initCalls.sqf"

//--- Not mission
if (_recompile in [0,1,2]) then {

    //--- uiNamespace init
    uiNamespace setVariable ["bis_fnc_init",true]
};

//--- Only mission variables
if (_recompile in [4]) then {

    //--- MissionNameSpace init
    missionNamespace setVariable ["bis_fnc_init",true];
};

//--- Only mission variables
if (_recompile in [1]) then {
    "Functions recompiled" call bis_fnc_log;
};

//--- Log the info about selected recompile type
private _recompileNames = [
    "ERROR: Autodetect failed",
    "Forced",
    "Core Only",
    "Mission/Campaign Only"
];
["Initialized: %1.",_recompileNames select _recompile] call (uiNamespace getVariable "bis_fnc_logFormat");
diag_log ("initFunctions.sqf Done: " + str(diag_tickTime));
