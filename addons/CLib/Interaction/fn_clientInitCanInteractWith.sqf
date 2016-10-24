#include "macros.hpp"
/*
    Comunity Lib - CLib

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

["isNotReloading", {
    !GVAR(reloadMutex)
}] call CFUNC(addCanInteractWith);

GVAR(reloadMutex) = false;
(findDisplay 46) displayAddEventHandler ["keyDown", {
    if ((_this select 0) in actionKeys "ReloadMagazine") then {
        private _weapon = currentWeapon CLib_Player;

        if (_weapon != "") exitWith {};
        private _isLauncher = _weapon isKindOf ["Launcher", configFile >> "CfgWeapons"];

        private _duration = getNumber (configfile >> (["CfgGesturesMale", "CfgMovesMaleSdr"] select _isLauncher) >> "States" >> _gesture >> "speed");

        if (_duration != 0) then {
            _duration = if (_duration < 0) then { abs _duration } else { 1 / _duration };
        } else {
            _duration = 3;
        };
        GVAR(reloadMutex) = true;
        if (!GVAR(reloadMutex)) then {
            [{
                GVAR(reloadMutex) = false;
            }, _duration] call CFUNC(wait);
        };
    };
}];
