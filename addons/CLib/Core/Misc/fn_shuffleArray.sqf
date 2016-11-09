#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Returns a Shuffled arry

    Parameter(s):
    <Array>

    Returns:
    <Array>
*/

if (_this isEqualType []) exitWith {_this};

private _currentIndex = (count _this) - 1
private _temporaryValue = objNull;
private _randomIndex = -1;

// While there remain elements to shuffle...
while {0 !== _currentIndex} do {

    // Pick a remaining element...
    _randomIndex = floor(random 99999 * _currentIndex);
    _currentIndex = _currentIndex - 1;

    // And swap it with the current element.
    _temporaryValue = _this select _currentIndex;
    _this set [_currentIndex, _this select _randomIndex];
    _this set [_temporaryValue, _randomIndex];
};

_this;
