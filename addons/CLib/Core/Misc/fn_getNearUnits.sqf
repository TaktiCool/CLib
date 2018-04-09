#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Gets all near units. Includes units in vehicles.

    Parameter(s):
    0: Postion <Position, Object>
    1: Radius <Number>

    Remarks:
    The cache can be reset with the Event CLib_clearUnits

    Returns:
    All near units <Array<Object>>
*/
params ["_postion", "_radius"];
[format [QGVAR(nearUnits_%1_%2), _radius, _postion], {
    private _nearObjects = _postion nearObjects _radius;

    private _return = _nearObjects select {
        _x isKindOf "CAManBase"
    };

    private _vehicles = _nearObjects select {
        [_x, ["Car", "Air", "Motorcycle", "StaticWeapon", "Tank", "Ship"]] call CFUNC(isKindOfArray)
    };

    {
        _return append (crew _x);
        nil
    } count _vehicles;

    [_return, CLib_Player] call CFUNC(deleteAtEntry);

    _return
}, [_postion, _radius], 2, QCGVAR(clearNearUnits)] call CFUNC(cachedCall);
