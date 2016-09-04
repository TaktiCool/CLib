#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: BadGuy

    Description:
    Updates the MapGraphicsCache

    Parameter(s):
    -

    Returns:
    -
*/
params ['_map'];
private _cache = [];

{
    private _graphicsGroupId = _x;
    private _graphicsGroup = GVAR(MapGraphicsGroup) getVariable _graphicsGroupId;
    _graphicsGroup params ["_layer", "_timestamp", "_state"];
    private _graphicsData = _graphicsGroup select (3 + _state);
    if (_graphicsData isEqualTo []) then {
        _graphicsData = _graphicsGroup select 3;
    };
    private _cData = _graphicsData apply { [_layer, _timestamp, _graphicsGroupId] + _x};
    _cache append _cData;
    nil;
} count ([GVAR(MapGraphicsGroup)] call CFUNC(allVariables));

_cache sort true;

GVAR(MapGraphicsCache) = _cache;
