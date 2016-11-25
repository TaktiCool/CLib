#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Updates the MapGraphicsCache

    Parameter(s):
    None

    Returns:
    None

*/
params ['_map'];
private _cache = [];

{
    private _graphicsGroupId = _x;
    private _graphicsGroup = GVAR(MapGraphicsGroup) getVariable _graphicsGroupId;
    if (!isNil "_graphicsGroup") then {
        _graphicsGroup params ["_layer", "_timestamp", "_state"];
        private _graphicsData = _graphicsGroup select (3 + _state);
        if (_graphicsData isEqualTo []) then {
            _graphicsData = _graphicsGroup select 3;
        };
        private _counter = 0;
        private _cData = _graphicsData apply {_counter = _counter + 1; [_layer, _timestamp, _graphicsGroupId, _counter] + _x};
        _cache append _cData;
    };

    nil;
} count ([GVAR(MapGraphicsGroup)] call CFUNC(allVariables));

_cache sort true;

GVAR(MapGraphicsCache) = _cache;
