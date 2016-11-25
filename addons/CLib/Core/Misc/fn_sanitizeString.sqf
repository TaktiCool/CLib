#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:


    Parameter(s):
    0: Argument Name <TYPE>

    Returns:
    0: Return Name <TYPE>
*/
params [["_string", "", [""]]];
private _array = [];

{
    if !(_x in (toArray '"\/*?<>|:')) then {
        _array pushBack _x;
    };
    nil
} count (toArray _string);

toString _array
