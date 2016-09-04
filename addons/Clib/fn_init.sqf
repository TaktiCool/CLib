#include "macros.hpp"
GVAR(allCustomNamespaces) = [];

GVAR(cachedCall) = call FUNC(createNamespace);
if (hasInterface) then {
    CLib_Player setVariable [QGVAR(playerName), profileName, true];
};

GVAR(ignoreVariables) = [toLower(QGVAR(PlayerInteraction_Actions)),toLower(QGVAR(tempUnit)), toLower(QGVAR(isProcessed)), toLower(QEGVAR(Revive,reviveEventhandlerAdded)), toLower(QEGVAR(Revive,damageWaitIsRunning))];

GVAR(allLocationTypes) = [];
{
    GVAR(allLocationTypes) pushBack (configName _x);
    nil
} count ("true" configClasses (configFile >> "CfgLocationTypes"));

GVAR(markerLocations) = getArray (missionConfigFile >> "PRA3" >> "markerLocation");
GVAR(markerLocations) = GVAR(markerLocations) apply {[_x, getMarkerPos _x, markerText _x]};

// functions for Disable User Input
DFUNC(onButtonClickEndStr) = {
    closeDialog 0;
    failMission 'LOSER';
    [false] call FUNC(disableUserInput);
} call FUNC(codeToString);

DFUNC(onButtonClickRespawnStr) = {
    closeDialog 0;
    forceRespawn CLib_Player;
    [false] call FUNC(disableUserInput);
} call FUNC(codeToString);


if (hasInterface) then {
    ["missionStarted", {
        (findDisplay 46) displayAddEventHandler ["KeyDown", {
            if ((_this select 1)==1) then {
                [{
                    private _pauseMenuDisplay = findDisplay 49;

                    _gY = ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
                    _gX = (((safezoneW / safezoneH) min 1.2) / 40);

                    _gY0 = SafeZoneY;
                    _gX0 = SafeZoneX;

                    private _controlGroup  = _pauseMenuDisplay ctrlCreate ["RscControlsGroupNoScrollbars",-1];
                    _controlGroup ctrlSetPosition [_gX0+safezoneW-10*_gX,_gY0+safezoneH-14*_gY,14*_gX,12*_gY];
                    _controlGroup ctrlCommit 0;

                    private _ctrl = _pauseMenuDisplay ctrlCreate ["RscPicture",-1,_controlGroup];
                    _ctrl ctrlSetPosition [0.25*_gX,0,8*_gX,8*_gY];
                    _ctrl ctrlSetText "ui\media\PRA3Logo_ca.paa";
                    _ctrl ctrlCommit 0;

                    _ctrl = _pauseMenuDisplay ctrlCreate ["RscText",-1,_controlGroup];
                    _ctrl ctrlSetPosition [0.5*_gX,8*_gY,8*_gX,1*_gY];
                    _ctrl ctrlSetText format ["Mission Version: %1", (GVAR(VersionInfo) select 0) select 0];
                    _ctrl ctrlCommit 0;

                    _ctrl = _pauseMenuDisplay ctrlCreate ["RscText",-1,_controlGroup];
                    _ctrl ctrlSetPosition [0.7*_gX,8.8*_gY,8*_gX,1*_gY];
                    _ctrl ctrlSetText format ["Server Version: %1", (GVAR(VersionInfo) select 1) select 0];
                    _ctrl ctrlCommit 0;

                    _ctrl = _pauseMenuDisplay ctrlCreate ["RscStructuredText",-1,_controlGroup];
                    _ctrl ctrlSetPosition [0*_gX,10*_gY,12*_gX,1*_gY];
                    _ctrl ctrlSetStructuredText parseText "<t size='1.2' font='PuristaBold'><a href='https://github.com/drakelinglabs/projectrealityarma3/blob/master/.github/CONTRIBUTING.md'>REPORT AN ISSUE</a></t>";
                    _ctrl ctrlCommit 0;
                }, {!isNull (findDisplay 49)}, []] call CFUNC(waitUntil);
            };
        }];
    }] call CFUNC(addEventhandler);

    // this fix a issue that Static Guns and Cars dont have right Damage on Lower LODs what mean you can not hit a Unit in a Static gun.
    // this fix the issue until BI fix this issue and prevent False Reports
    GVAR(staticVehicleFix) = [];
    ["entityCreated", {
        params ["_args"];
        if (_args isKindOf "Car" || _args isKindOf "StaticWeapon") then {
            private _id = GVAR(staticVehicleFix) pushBackUnique _args;
            if (_id != -1) then {
                [{}, {
                    1 preloadObject _this;
                }, _args] call CFUNC(waitUntil);
            };
        };
        GVAR(staticVehicleFix) = GVAR(staticVehicleFix) - [objNull];
    }] call CFUNC(addEventhandler);


    // Disable all Radio Messages
    enableSentences false;
    enableRadio false;

    ["playerChanged", {
        (_this select 0) params ["_newPlayer"];
        _newPlayer disableConversation true;
        _newPlayer setVariable ["BIS_noCoreConversations", false];
    }] call CFUNC(addEventhandler);

    ["entityCreated", {
        params ["_args"];
        if (_args isKindOf "CAManBase") then {
            _args disableConversation true;
            _args setVariable ["BIS_noCoreConversations", true];
        };
    }] call CFUNC(addEventhandler);

};
