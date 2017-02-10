#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init of the interact restriction system

    Parameter(s):
    None

    Returns:
    None
*/
// [CLib_Player, CLib_Player,["inNotVehicle", "isNotSwimming", "isNotDead", "isNotOnMap", "isNotUnconscious", "isNotDragging"]] call CLib_fnc_canInteractWith;

// ["isNotInVehicle", "isNotSwimming", "isNotDead", "isNotOnMap", "isNotUnconscious", "isNotDragging"]

["isNotInVehicle", {
    (isNull objectParent _caller) && (isNull objectParent _target)
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
                private _anim = getText (configFile >> "CfgWeapons" >> _weapon >> "reloadAction");
                if (_anim == "") exitWith {}; //Ignore weapons with no reload gesture (binoculars)

                private _isLauncher = _weapon isKindOf ["Launcher", configFile >> "CfgWeapons"];

                private _duration = getNumber (configFile >> (["CfgGesturesMale", "CfgMovesMaleSdr"] select _isLauncher) >> "States" >> _anim >> "speed");

                if (_duration != 0) then {
                    _duration = if (_duration < 0) then {abs _duration} else {1 / _duration};
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
