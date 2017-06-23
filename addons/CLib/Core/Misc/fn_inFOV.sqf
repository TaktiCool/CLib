#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    checks if a Position is in FOV of a Object

    Parameter(s):
    0: Unit/Object <Object>
    1: Position <Object, Postition>
    2: Size <Number>

    Returns:
    In FOV <Bool>
*/
params ["_obj", "_target", "_size"];
(abs(RELDIR(_obj, _target)) < (_size atan2 (_obj distance _target)));
