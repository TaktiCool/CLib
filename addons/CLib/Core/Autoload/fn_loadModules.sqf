#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: NetFusion

    Description:
    Entry point for module loading. Must be called within mission script for client and server. Start transfer of functions.

    Parameter(s):
    the names of the requested modules <ARRAY> ()

    Returns:
    None

*/

// The client waits for the player to be available. This makes sure the player variable is initialized in every script later.
if (hasInterface) then {

    // Skip Briefing. we need to do this because else the player can get stucked in the briefing screen with the server have allready triggered the mission started Event.
    // yes i also dont like this BUT at this point PFH and other Eventhandler are not Initialized and PFH dont trigger in the briefing Screen
    call {
        if (!isNumber (missionConfigFile >> "briefing")) exitWith {};
        if (getNumber (missionConfigFile >> "briefing") == 1) exitWith {};

            private _d = (getNumber (configfile >> "RscDisplayServerGetReady" >> "idd"));
            waitUntil {
                if (getClientState == "BRIEFING READ") exitWith {true};
                if (!isNull findDisplay _d) exitWith {
                    ctrlActivate (findDisplay _d displayCtrl 1);
                    findDisplay _d closeDisplay 1;
                    true
                };
                false
            };
    };
    waitUntil {!isNull player};
    CLib_Player = player;
    waitUntil {CGVAR(playerUID) = getPlayerUID player; (CGVAR(playerUID) != "")};
    waitUntil {!isNil QCFUNC(decompressString)};

    // Start the loading screen on the client to prevent a drawing lag while loading. Disable input too to prevent unintended movement after spawn.
    [QCGVAR(loadModules)] call bis_fnc_startLoadingScreen;
    disableUserInput true;
};

private _cfg = missionConfigFile >> (QPREFIX + "_Modules");

if (!(isArray _cfg) && (isNil "_this" || {_this isEqualTo []})) exitWith {
    endLoadingScreen;
    disableUserInput false;
    LOG("No CLib Modules will get Loaded in the mission")
};

// If the machine has CLib running and is the Server exit to the server LoadModules
if (isClass (configFile >> "CfgPatches" >> "CLib")) exitWith {
    // clients are not allowed to load CLib localy its Only a Server mod
    if (!isServer) exitWith {
        LOG("CLib is a Server Mod Dont Load it on a Client")
        endLoadingScreen;
        disableUserInput false;
        endMission "LOSER";
    };

    if (!(isNil "_this") && {!(_this isEqualTo [])}) then {
        [FUNC(loadModulesServer), _this] call CFUNC(directCall);
    } else {
        [FUNC(loadModulesServer), getArray _cfg] call CFUNC(directCall);
    };
};

// Bind EH on client to compile the received function code. Collect all functions names to determine which need to be called later in an array.
GVAR(requiredFunctions) = [];
QGVAR(receiveFunction) addPublicVariableEventHandler {
    (_this select 1) params ["_functionVarName", "_functionCode", "_progress"];

    DUMP("Function Recieved: " + _functionVarName)

    // Compile the function code and assign it.
    if (CGVAR(useFunctionCompression)) then {
        _functionCode = _functionCode call CFUNC(decompressString);
    };
    _functionCode = cmp _functionCode;

    {
        #ifdef isDev
            _x setVariable [_functionVarName, _functionCode];
        #else
            if (isNil {(_x getVariable _functionVarName)}) then {
                _x setVariable [_functionVarName, _functionCode];
            } else {
                if !((_x getVariable _functionVarName) isEqualTo _functionCode) then {
                    private _log = format ["[CLib: CheatWarning!]: Player %1(%2) allready have ""%3""!", profileName, GVAR(playerUID), _functionVarName];

                    LOG(_log);
                    GVAR(sendlogfile) = [_log, "CLib_SecurityLog"];
                    publicVariableServer QGVAR(sendlogfile);
                    ["Warning Function %1 is corrupted on your Client, Please restart your Client.", _functionVarName] call BIS_fnc_errorMsg;
                    GVAR(unregisterClient) = player;
                    publicVariableServer QGVAR(unregisterClient);
                    endLoadingScreen;
                    disableUserInput false;
                    endMission "LOSER";
                };
            };
        #endif
        nil
    } count [missionNamespace, uiNamespace, parsingNamespace];

    // Update the loading screen with the progress.
    _progress call bis_fnc_progressloadingscreen;
    DUMP("LoadModules Progress: " + str _progress)

    // Store the function name.
    GVAR(requiredFunctions) pushBackUnique _functionVarName;

    // If the progress is 1 the last function code is received.
    if (_progress >= 1) then {
        DUMP("All Function Recieved, now call then")

        // Call all modules.
        call FUNC(callModules);
    };
};

// Register client at the server to start transmission of function codes.
GVAR(registerClient) = player;
publicVariableServer QGVAR(registerClient);
