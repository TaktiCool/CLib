#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Draws the map icons on map

    Parameter(s):
    0: Map <Control>

    Returns:
    None
*/
params ["_map"];

private _mapScale = ctrlMapScale _map;
private _cache = [];

"DrawMapGraphics" call CFUNC(localEvent);

if (GVAR(MapGraphicsCacheVersion) != GVAR(MapGraphicsCacheBuildFlag)) then {
    GVAR(MapGraphicsCacheVersion) = GVAR(MapGraphicsCacheBuildFlag);
    call CFUNC(buildMapGraphicsCache);
};
// iterate through all mapGraphic objects
{
    _x params ["_layer","_timestamp","_groupId", "_itemNumber"];
    private _iconData = _x select [4, count _x - 4];

    switch (_iconData select 0) do {
        case ("ICON"): {
            _iconData params ["_type", "_texture", "_color", "_position", "_width", "_height", "_angle", "_text", "_shadow", "_textSize", "_font", "_align", "_code"];
            call _code;

            if (_angle isEqualType objNull) then {
                _angle = getDirVisual _angle;
            };

            _position = [_position, _map] call CFUNC(mapGraphicsPosition);

            if (_mapScale < 0.1) then {
                _textSize = _textSize*((_mapScale/0.1) max 0.5);
            };

            _map drawIcon [_texture, _color, _position, _width, _height, _angle, _text, _shadow, _textSize, _font, _align];
            _cache pushBack [_groupId, _position, _width*3*_mapscale*worldSize/(4096), _height*3*_mapscale*worldSize/(4096), _angle, true];
        };
        case ("RECTANGLE"): {
            _iconData params ["_type","_position", "_width", "_height", "_angle", "_lineColor", "_fillColor", "_code"];
            call _code;

            if (_angle isEqualType objNull) then {
                _angle = getDirVisual _angle;
            };

            _position = [_position, _map] call CFUNC(mapGraphicsPosition);

            _map drawRectangle [_position, _width, _height, _angle, _lineColor, _fillColor];
            _cache pushBack [_groupId, _position, _width, _height, _angle, true];
        };
        case ("ELLIPSE"): {
            _iconData params ["_type","_position", "_width", "_height", "_angle", "_lineColor", "_fillColor", "_code"];
            call _code;

            if (_angle isEqualType objNull) then {
                _angle = getDirVisual _angle;
            };

            _position = [_position, _map] call CFUNC(mapGraphicsPosition);

            _map drawEllipse [_position, _width, _height, _angle, _lineColor, _fillColor];
            _cache pushBack [_groupId, _position, _width, _height, _angle, false];
        };
        case ("LINE"): {
            _iconData params ["_type","_pos1", "_pos2", "_lineColor", "_code"];
            call _code;

            _pos1 = [_pos1, _map] call CFUNC(mapGraphicsPosition);
            _pos2 = [_pos2, _map] call CFUNC(mapGraphicsPosition);

            _map drawLine [_pos1, _pos2, _lineColor];
        };
        case ("ARROW"): {
            _iconData params ["_type","_pos1", "_pos2", "_lineColor", "_code"];
            call _code;

            _pos1 = [_pos1, _map] call CFUNC(mapGraphicsPosition);
            _pos2 = [_pos2, _map] call CFUNC(mapGraphicsPosition);

            _map drawArrow [_pos1, _pos2, _lineColor];
        };
        case ("POLYGON"): {
            _iconData params ["_type","_positions", "_lineColor", "_code"];
            call _code;
            private _temp = _positions apply {
                [_x, _map] call CFUNC(mapGraphicsPosition);
            };

            _map drawPolygon [_temp, _lineColor];
        };
    };


    nil
} count GVAR(MapGraphicsCache);

GVAR(MapGraphicsGeometryCache) = _cache;
