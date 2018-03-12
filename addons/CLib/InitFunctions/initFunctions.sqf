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

if (isNil "BIS_fnc_MP_packet") then {BIS_fnc_MP_packet = compileFinal ""}; //--- is not used anymore and so it should not be used anymore

//--- Fake header
_fnc_scriptName = if (isNil "_fnc_scriptName") then {"Functions Init"} else {_fnc_scriptName};

#include "compile.sqf"

//--- Compile only selected
if (isNil "_this") then {_this = [];};
if !(_this isEqualType []) then {_this = [_this];};
params [["_recompile", 0]];

#include "singleCompile.sqf"

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
                    #include "compileLoop.sqf"
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

#include "initCalls.sqf"

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
