#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Adds a 3D Icon to the System

    Parameter(s):
    0: Id <String>
    1: GraphicsData <Array>
        0: Class <STRING> (ICON | LINE)
        Class = "ICON":
            1: Texture <String>
            2: Color <Array> [r,g,b,a]
            3: Position <3dGraphicsPosition>
            4: Width <Number>
            5: Height <Number>
            6: Angle <Number>
            7: Text <String>
            8: Shadow <Number>
            9: Text Size <Number>
            10: Font <String>
            11: textAlign <String>
            12: draw Side Arrows <Boolean>
        Class = "LINE":
            1: Start <MapGraphicsPosition>
            2: End <MapGraphicsPosition>
            3: Line Color <Array> [r,g,b,a]
        last element (13 | 4): Code <Code> called every frame (returns visibility <boolean>)

    Remarks:
    TYPE <3dGraphicsPosition>:
    OBJECT | POSITIONAGL | [OBJECT, [ObjectOffsetX, ObjectOffsetY, ObjectOffsetZ]]


    Returns:
    None
*/

params ["_id", "_graphicsData"];

private _completeGraphicsData = [];

{
    _x params ["_class"];
    private _attributes = _x select [1, count _x - 1];
    switch (_class) do {
        case ("ICON"): {
            _attributes params [
                ["_texture",""],
                ["_color",[0, 0, 0, 1]],
                ["_position", objNull, [[], objNull]],
                ["_width", 1],
                ["_height", 1],
                ["_angle", 0],
                ["_text",""],
                ["_shadow", 2],
                ["_textSize", 0.05],
                ["_font", "PuristaSemiBold"],
                ["_align","center"],
                ["_drawSideArrows",false],
                ["_code",{true}]
            ];
            _completeGraphicsData pushBack [_class, _texture, _color, _position, _width, _height, _angle, _text, _shadow, _textSize, _font, _align, _drawSideArrows, _code];
        };
        case ("LINE"): {
            _attributes params [
                ["_start", objNull, [[], objNull]],
                ["_end", objNull, [[], objNull]],
                ["_lineColor",[0, 0, 0, 1]],
                ["_code",{true}]
            ];
            _completeGraphicsData pushBack [_class, _start, _end, _lineColor, _code];
        };
    };
    nil;
} count _graphicsData;

[GVAR(3dGraphicsNamespace), _id, _completeGraphicsData] call CFUNC(setVariable);
GVAR(3dGraphicsCacheBuildFlag) = GVAR(3dGraphicsCacheBuildFlag) + 1;
