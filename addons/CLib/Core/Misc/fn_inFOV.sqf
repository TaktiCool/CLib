#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if a target is in FOV of an object

    Parameter(s):
    0: Object <Object> (Default: objNull)
    1: Target <Object, Array> (Default: objNull)
    2: Width of target <Number> (Default: 0)

    Returns:
    In FOV <Bool>
*/

params [
    ["_obj", objNull, [objNull]],
    ["_target", objNull, [objNull, []]],
    ["_width", 0, [0]]
];

(abs RELDIR(_obj,_target) < (_width atan2 (_obj distance _target)));
