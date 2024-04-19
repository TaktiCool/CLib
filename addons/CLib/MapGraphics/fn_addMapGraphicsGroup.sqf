#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Adds a new group to the MapGraphics system

    Parameter(s):
    0: Group Name <String> (Default: "")
    1: Group Data <Array> (Default: [])
    2: State <String> (Default: "normal")
    3: Group Layer <Number> (Default: 0)

    Returns:
    None

    Remarks:
    Group Data is defined as <ARRAY> of GraphicsElements of following Structure:
        0: Class <STRING> (ICON | RECTANGLE | ELLIPSE | LINE | ARROW | POLYGON)
        Class = "ICON":
            1: Texture <String>
            2: Color <Array> [r,g,b,a]
            3: Position <MapGraphicsPosition>
            4: Width <Number>
            5: Height <Number>
            6: Angle <Number>
            7: Text <String>
            8: Shadow <Boolean/Number>
            9: Text Size <Number>
            10: Font <String>
            11: Align <String>
        Class = "RECTANGLE":
            1: Center Position <MapGraphicsPosition>
            2: Width <Number | ['m','screen', NUMBER]>
            3: Height <Number | ['m','screen', NUMBER]>
            4: Angle <Number>
            5: Line Color <Array> [r,g,b,a]
            6: Fill Color <Array> [r,g,b,a]
        Class = "ELLIPSE":
            1: Center Position <MapGraphicsPosition>
            2: Width <Number | ['m','screen', NUMBER]>
            3: Height <Number | ['m','screen', NUMBER]>
            4: Angle <Number>
            5: Line Color <Array> [r,g,b,a]
            6: Fill Color <Array> [r,g,b,a]
        Class = "LINE":
            1: Position 1 <MapGraphicsPosition>
            2: Position 2 <MapGraphicsPosition>
            3: Line Color <Array> [r,g,b,a]
        Class = "ARROW":
            1: Position 1 <MapGraphicsPosition>
            2: Position 2 <MapGraphicsPosition>
            3: Line Color <Array> [r,g,b,a]
        Class = "POLYGON":
            1: Positions <Array> of MapGraphicsPosition
            2: Line Color <Array> [r,g,b,a]
        last element: Code <Code> called every frame
        Class = "TRIANGLE"
            1: Positions <Array> of <Array> of MapGraphicsPosition
            2: Line Color <Array> [r,g,b,a]
            3: Fill Color <Array> [r,g,b,a]

    TYPE <MapGraphicsPosition>:
    OBJECT | POSITION3D | POSITION2D | [OBJECT | POSITION3D | POSITION2D,[ScreenOffsetX,ScreenOffsetY]]
*/

params [
    ["_groupName", "", [""]],
    ["_groupData", [], [[]], []],
    ["_state", "normal", [""]],
    ["_layer", 0, [0]]
];

// Compete the data for the map graphics cache
private _completeGroupData = [];
{
    _x params ["_class"];
    private _attributes = _x select [1, count _x - 1];
    switch (_class) do {
        case ("ICON"): {
            _attributes params [
                ["_texture", ""],
                ["_color", [0, 0, 0, 1]],
                ["_position", objNull, [[], objNull]],
                ["_width", 25],
                ["_height", 25],
                ["_angle", 0, [0, objNull]],
                ["_text", ""],
                ["_shadow", 0],
                ["_textSize", 0.08],
                ["_font", "PuristaMedium"],
                ["_align", "right"],
                ["_code", {}],
                ["_customCodeArgs", []]
            ];
            _completeGroupData pushBack [_class, _texture, _color, _position, _width, _height, _angle, _text, _shadow, _textSize, _font, _align, _code, _customCodeArgs];
        };
        case ("RECTANGLE"): {
            _attributes params [
                ["_position", objNull, [[], objNull]],
                ["_width", 25, [0, []]],
                ["_height", 25, [0, []]],
                ["_angle", 0, [0, objNull]],
                ["_lineColor", [0, 0, 0, 1]],
                ["_fillColor", ""],
                ["_code", {}],
                ["_customCodeArgs", []]
            ];
            _completeGroupData pushBack [_class, _position, _width, _height, _angle, _lineColor, _fillColor, _code, _customCodeArgs];
        };
        case ("ELLIPSE"): {
            _attributes params [
                ["_position", objNull, [[], objNull]],
                ["_width", 25, [0, []]],
                ["_height", 25, [0, []]],
                ["_angle", 0, [0, objNull]],
                ["_lineColor", [0, 0, 0, 1]],
                ["_fillColor", ""],
                ["_code", {}],
                ["_customCodeArgs", []]
            ];
            _completeGroupData pushBack [_class, _position, _width, _height, _angle, _lineColor, _fillColor, _code, _customCodeArgs];
        };
        case ("LINE"): {
            _attributes params [
                ["_position1", objNull, [[], objNull]],
                ["_position2", objNull, [[], objNull]],
                ["_color", [0, 0, 0, 1]],
                ["_code", {}],
                ["_customCodeArgs", []]
            ];
            _completeGroupData pushBack [_class, _position1, _position2, _color, _code, _customCodeArgs];
        };
        case ("ARROW"): {
            _attributes params [
                ["_position1", objNull, [[], objNull]],
                ["_position2", objNull, [[], objNull]],
                ["_color", [0, 0, 0, 1]],
                ["_code", {}],
                ["_customCodeArgs", []]
            ];
            _completeGroupData pushBack [_class, _position1, _position2, _color, _code, _customCodeArgs];
        };
        case ("POLYGON"): {
            _attributes params [
                ["_polygon", []],
                ["_color", [0, 0, 0, 1]],
                ["_code", {}],
                ["_customCodeArgs", []]
            ];
            _completeGroupData pushBack [_class, _polygon, _color, _code, _customCodeArgs];
        };
        case ("TRIANGLE"): {
            _attributes params [
                ["_tris", []],
                ["_lineColor", [0, 0, 0, 1]],
                ["_fillColor", ""],
                ["_code", {}],
                ["_customCodeArgs", []]
            ];
            _completeGroupData pushBack [_class, _tris, _lineColor, _fillColor, _code, _customCodeArgs];
        };
    };
} forEach _groupData;

// select the correct state
private _stateNum = 0 max (["normal", "hover", "selected"] find _state);

// save the data
private _currentIcon = GVAR(MapGraphicsGroup) getVariable [_groupName, [_layer, 0, 0, [], [], []]];
_currentIcon set [_stateNum + 3, _completeGroupData];
_currentIcon set [1, time];
[GVAR(MapGraphicsGroup), _groupName, _currentIcon] call CFUNC(setVariable);
// increment map graphics cache
GVAR(MapGraphicsCacheBuildFlag) = GVAR(MapGraphicsCacheBuildFlag) + 1;
nil
