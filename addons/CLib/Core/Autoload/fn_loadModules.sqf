#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Entry point for module loading. Must be called within mission script for client and server. Start transfer of functions.

    Parameter(s):
    0: The names of the requested modules <Array>

    Returns:
    None
*/

diag_log text format ["[CLib - Version]: Server Version %1", CGVAR(VersionInfo)];
diag_log text format ["[CLib]: isServer: %1 isDedicated: %2 hasInterface: %3 isMultiplayer: %4 isMultiplayerSolo: %5", isServer, isDedicated, hasInterface, isMultiplayer, isMultiplayerSolo];
diag_log text format ["[CLib]: useCompression: %1 useFallbackRemoteExecution: %2 useExperimentalAutoload: %3", CGVAR(useCompression), CGVAR(useRemoteFallback), CGVAR(useExperimentalAutoload)];

// Skip the briefing by pressing the continue button on behalf of the user
// http://killzonekid.com/arma-scripting-tutorials-how-to-skip-briefing-screen-in-mp/

0 spawn {
    if (!isNumber (missionConfigFile >> "briefing")) exitWith {};
    if (getNumber (missionConfigFile >> "briefing") == 1) exitWith {};

    private _displayIdd = getNumber (configFile >> (["RscDisplayClientGetReady", "RscDisplayServerGetReady"] select (isServer)) >> "idd");
    waitUntil {
        if (getClientStateNumber >= 10) exitWith {true};

        disableSerialization;
        private _display = findDisplay _displayIdd;
        if (!isNull _display) exitWith {
            ctrlActivate (_display displayCtrl 1);
            _display closeDisplay 1;
            true
        };
        false
    };
};

CGVAR(loadingIsFinished) = false;
GVAR(loadingCanceled) = false;
// The client waits for the player to be available. This makes sure the player variable is initialized in every script later.
if (hasInterface) then {
    // Briefing is over
    waitUntil {!isNull player};
    CLib_Player = player;
    waitUntil {getPlayerUID player != ""};
    CGVAR(playerUID) = getPlayerUID player;
    waitUntil {!isNil QCFUNC(decompressString)};

    // Start the loading screen on the client to prevent a drawing lag while loading. Disable input too to prevent unintended movement after spawn.
    [QCGVAR(loadModules)] call BIS_fnc_startLoadingScreen;
    disableUserInput true;
};

private _cfg = missionConfigFile >> QPREFIX >> "Modules";
if (!(isArray _cfg) && (isNil "_this" || {_this isEqualTo []})) exitWith {
    [QCGVAR(loadModules)] call BIS_fnc_endLoadingScreen;
    disableUserInput false;
    diag_log text "No CLib Modules loaded in the mission";
};

// If the machine has CLib running and is the Server exit to the server LoadModules
if (isClass (configFile >> "CfgPatches" >> QPREFIX)) exitWith {
    // clients are not allowed to load CLib localy its Only a Server mod
    if (!isServer) exitWith {
        diag_log text "------------------------- CRITICAL ERROR -------------------------";
        diag_log text "CRITICAL ERROR: CLib is a server mod - do not load it on a client!";

        disableUserInput false;

        compile preprocessFileLineNumbers "\tc\CLib\addons\CLib\Core\Autoload\fn_crashToDesktop.sqf"; // Crashes Client to Desktop
    };

    if (!(isNil "_this") && {_this isNotEqualTo []}) then {
        [FUNC(loadModulesServer), _this] call CFUNC(directCall);
    } else {
        [FUNC(loadModulesServer), getArray _cfg] call CFUNC(directCall);
    };
};

// Bind EH on client to compile the received function code. Collect all functions names to determine which need to be called later in an array.
GVAR(requiredFunctions) = [];
QGVAR(receiveFunction) addPublicVariableEventHandler {
    if (GVAR(loadingCanceled)) exitWith {};
    (_this select 1) params ["_functionVarName", "_functionCode", "_progress"];

    DUMP("Function Recieved: " + _functionVarName);

    // Compile the function code and assign it.
    if (USE_COMPRESSION(true)) then {
        _functionCode = _functionCode call CFUNC(decompressString);
    };
    _functionCode = CMP(_functionCode);

    {
        #ifdef ISDEV
            _x setVariable [_functionVarName, _functionCode];
        #else
            if (isNil {(_x getVariable _functionVarName)}) then {
                _x setVariable [_functionVarName, _functionCode];
            } else {
                if !((_x getVariable _functionVarName) isEqualTo _functionCode) then {
                    private _log = format ["[CLib: CheatWarning!]: Player %1(%2) allready have ""%3"" as Function Defined and is Different to the current Use Version!", profileName, GVAR(playerUID), _functionVarName];
                    LOG(_log);

                    GVAR(sendlogfile) = [_log, "CLib_SecurityLog"];
                    publicVariableServer QGVAR(sendlogfile);
                    _functionVarName spawn {
                        waitUntil {missionnamespace getVariable ["BIS_fnc_startLoadingScreen_ids", []] isEqualTo []};
                        [
                            format ["Warning function %1 is corrupted on your client, please restart your client.", _this],
                            "[CLib Anti Cheat Warning]"
                        ] call BIS_fnc_guiMessage;
                        GVAR(unregisterClient) = player;
                        publicVariableServer QGVAR(unregisterClient);
                        GVAR(loadingCanceled) = true;
                        [QCGVAR(loadModules)] call BIS_fnc_endLoadingScreen;
                        disableUserInput false;
                        endMission "LOSER";
                    };
                };
            };
        #endif
        nil
    } count [missionNamespace, localNamespace, uiNamespace, parsingNamespace];

    // Update the loading screen with the progress.
    _progress call BIS_fnc_progressloadingscreen;
    DUMP("LoadModules Progress: " + str _progress);

    // Store the function name.
    GVAR(requiredFunctions) pushBackUnique _functionVarName;

    // If the progress is 1 the last function code is received.
    if (_progress >= 1) then {
        DUMP("All Function Recieved, now call then");

        // Call all modules.
        call FUNC(callModules);
    };
};

// Register client at the server to start transmission of function codes.
GVAR(registerClient) = player;
publicVariableServer QGVAR(registerClient);
