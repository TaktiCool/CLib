#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    get All Near Units even in Vehicles

    Parameter(s):
    0: Postion <Position, Object>
    1: Raduis <Number>

    Remarks:
    the cache can be rest with the Event CLib_clearUnits

    Returns:
    All Near units <Array<Object>>
*/
params ["_postion", "_radius"];
[format [QGVAR(nearUnits_%1), _radius], {
    private _nearObjects = _postion nearObjects _radius;

    private _return = _nearObjects select {
        _x isKindOf "CAManBase"
    };

    private _vehicles = _nearObjects select {
        _x isKindOf "Car" || _x isKindOf "Air" || _x isKindOf "Motorcycle" ||
        _x isKindOf "StaticWeapon" || _x isKindOf "Tank" || _x isKindOf "Ship"
    };

    {
        _return append (crew _x);
        nil
    } count _vehicles;

    [_return, CLib_Player] call CFUNC(deleteAtEntry);

    _return
}, [_postion, _radius], 2, QGVAR(clearNearUnits)] call CFUNC(cachedCall);
