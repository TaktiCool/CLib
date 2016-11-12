#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas, NetFusion

    Description:
    Returns a shuffled array.
    See https://en.wikipedia.org/wiki/Fisher-Yates_shuffle for details.

    Parameter(s):
    <Array>

    Returns:
    <Array>
*/

// Create a copy to prevent modifying the original array.
private _returnArray = +_this;

// Cycle through all elements of the array...
{
    // Pick a random element...
    private _randomIndex = floor random _forEachIndex;

    // If the chosen element differs we replace it.
    if (_randomIndex != _forEachIndex) then {
        _returnArray set [_forEachIndex, _returnArray select _randomIndex];
    };

    // Place the current element at the free position.
    _returnArray set [_randomIndex, _this select _forEachIndex];
} forEach _this;

_returnArray
