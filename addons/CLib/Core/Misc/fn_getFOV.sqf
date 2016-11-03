#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Calculate Current FOV and Zoom

    Parameter(s):
    None

    Returns:
    FOV <Number>
*/

([0.5,0.5] distance2D worldToScreen positionCameraToWorld [0,3,4]) * (getResolution select 5) / 2
