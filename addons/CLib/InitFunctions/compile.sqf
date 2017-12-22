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

private ["_this","_debug","_headerDefault","_fncCompile","_recompile"];

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
_debug = uiNamespace getVariable ["BIS_fnc_initFunctions_debugMode",0];
_headerDefault = switch _debug do {

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
_fncCompile = {
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
