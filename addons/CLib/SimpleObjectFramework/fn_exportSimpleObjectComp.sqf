#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Exports selected 3den objects to SimpleObjectFramework Config structure

    Parameter(s):
    None

    Returns:
    None
*/

private _objects = get3DENSelected "object";
private _meanPos = [0,0,0];
private _numPos = {
    _meanPos = _meanPos vectorAdd getPosWorld _x;
    true;
} count _objects;

_meanPos = _meanPos apply {_x / _numPos};
_meanPos set [2, getTerrainHeightASL _meanPos];
private _output = "";
{
    private _data = format ["class item%1 {", _forEachIndex] + toString [10];
    private _path = getModelInfo _x select 1;
    private _pos = (getPosWorld _x) vectorDiff _meanPos;
    private _dir = vectorDir _x;
    private _up = vectorUp _x;
    _output = _output + _data;
    _output = _output + format ["     path = ""%1"";", _path] + toString [10];
    _output = _output + format ["     offset[] = {%1, %2, %3};", _pos select 0, _pos select 1, _pos select 2] + toString [10];
    _output = _output + format ["     dirVector[] = {%1, %2, %3};", _dir select 0, _dir select 1, _dir select 2] + toString [10];
    _output = _output + format ["     upVector[] = {%1, %2, %3};", _up select 0, _up select 1, _up select 2] + toString [10];
    _output = _output + "};" + toString [10];

} forEach _objects;

copyToClipboard _output;
