#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    [Description]

    Parameter(s):
    0: Argument Name <TYPE>

    Returns:
    0: Return Name <TYPE>
*/
// [CLib_Player, CLib_Player,["inNotVehicle", "isNotSwimming", "isNotDead", "isNotOnMap", "isNotUnconscious", "isNotDragging"]] call CLib_fnc_canInteractWith;


// ["isNotInVehicle", "isNotSwimming", "isNotDead", "isNotOnMap", "isNotUnconscious", "isNotDragging"]

["isNotInVehicle", {
    vehicle _caller == _caller && vehicle _target == _target
}] call CFUNC(addCanInteractWith);

["isNotSwimming", {
    !underwater _caller && !underwater _target
}] call CFUNC(addCanInteractWith);

["isNotDead", {
    alive _caller && alive _target
}] call CFUNC(addCanInteractWith);

["isNotOnMap", {
    !visibleMap
}] call CFUNC(addCanInteractWith);

GVAR(reloadMutex) = false;

["isNotReloading", {
    !GVAR(reloadMutex)
}] call CFUNC(addCanInteractWith);

["missionStarted", {
    private _fnc_reloadMutex = {
        GVAR(reloadMutex) = false;
        (findDisplay 46) displayAddEventHandler ["keyDown", {
            if ((_this select 1) in actionKeys "ReloadMagazine") then {
                private _weapon = currentWeapon CLib_Player;

                if (_weapon isEqualTo "") exitWith {};
                private _anim  = getText (configfile >> "CfgWeapons" >> _weapon >> "reloadAction");
                if (_anim == "") exitWith {}; //Ignore weapons with no reload gesture (binoculars)

                private _isLauncher = _weapon isKindOf ["Launcher", configFile >> "CfgWeapons"];

                private _duration = getNumber (configfile >> (["CfgGesturesMale", "CfgMovesMaleSdr"] select _isLauncher) >> "States" >> _anim >> "speed");

                if (_duration != 0) then {
                    _duration = if (_duration < 0) then { abs _duration } else { 1 / _duration };
                } else {
                    _duration = 3;
                };
                if (!GVAR(reloadMutex)) then {
                    GVAR(reloadMutex) = true;
                    [{
                        GVAR(reloadMutex) = false;
                    }, _duration] call CFUNC(wait);
                };
            };
        }];
    };
    [_fnc_reloadMutex, {
        !isNull (findDisplay 46)
    }] call CFUNC(waitUntil);
}] call CFUNC(addEventhandler);
