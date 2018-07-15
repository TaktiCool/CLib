#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Removes all Not needed 0 from toFixed numbers and returls only the max toFixed number count that is required.

    Parameter(s):
    Number <Number>

    Returns:
    Number in a String form <String>
*/
params [["_number", 0, [0]]];

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
