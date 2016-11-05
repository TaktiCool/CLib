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
    _meanPos = _meanPos vectorAdd getPosATL _x;
    true;
} count _objects;

_meanPos = _meanPos apply {_x / _numPos};
_meanPos set [2, 0];
private _output = "";
private _k = 0;
{
    _output = format ["%1class item%2 {", _output, _k] + toString [10];
    private _path = getModelInfo _x select 1;
    private _pos = (getPosATL _x) vectorDiff _meanPos;
    private _dir = vectorDir _x;
    private _up = vectorUp _x;
    _output = format ["%1     path = ""%2"";", _output, _path] + toString [10];
    _output = format ["%1     offset[] = {%2, %3, %4};", _output, _pos select 0, _pos select 1, _pos select 2] + toString [10];
    _output = format ["%1     dirVector[] = {%2, %3, %4};", _output, _dir select 0, _dir select 1, _dir select 2] + toString [10];
    _output = format ["%1     upVector[] = {%2, %3, %4};", _output, _up select 0, _up select 1, _up select 2] + toString [10];
    _output = _output + "};" + toString [10];
    _k = _k + 1;
} count _objects;

copyToClipboard _output;
