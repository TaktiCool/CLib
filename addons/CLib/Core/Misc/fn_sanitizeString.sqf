#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Removes all special characters from a string that could be displayed in a weird way or cause other problems

    Parameter(s):
    0: String <String> (Default: "")

    Returns:
    Sanitized string <String>
*/

params [
    ["_string", "", [""]]
];

private _array = [];
private _symbols = toArray "\/*""?<>|:";

{
    if !(_x in _symbols) then {
        _array pushBack _x;
    };
} forEach (toArray _string);

toString _array
