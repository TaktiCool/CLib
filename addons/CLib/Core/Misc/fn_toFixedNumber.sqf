#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Removes all trailing zeros from a decimal number

    Parameter(s):
    0: Number <Number> (Default: 0)

    Returns:
    Number in a String form <String>
*/

params [
    ["_number", 0, [0]]
];

private _strNumber = _number toFixed 20;

private _arrNumbers = toArray _strNumber;
reverse _arrNumbers;
while {(_arrNumbers select 0) isEqualTo 48} do {
    _arrNumbers deleteAt 0
};
if ((_arrNumbers select 0) isEqualTo 46) then {
    _arrNumbers deleteAt 0
};
reverse _arrNumbers;
toString _arrNumbers;
