#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: joko // Jonas

    Description:
    [Description]

    Parameter(s):
    0: Argument Name <TYPE>

    Returns:
    0: Return Name <TYPE>
*/
// [CLib_Player, CLib_Player,["inNotVehicle", "isNotSwimming", "isNotDead", "isNotOnMap", "isNotUnconscious", "isNotDragging"]] call PRA3_Core_fnc_canInteractWith;


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
