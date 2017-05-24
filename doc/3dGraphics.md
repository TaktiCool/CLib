# 3dGraphics

> Maintainer: BadGuy

The 3dGraphics module is a system built around the SQF commands [`drawIcon3D`] and [`drawLine3D`].


## Graphics Data

Graphics data is an array representing an 3d graphic. Currently there are two types of graphics supported: [`ICON`] and [`LINE`].
The required data is different depending on the graphic type.

### Icon data

* [`<String>`] Graphics type (should be `"ICON"`)
* [`<String>`] Texture
* [`<Color>`] Color
* [`<3dGraphicsPosition>`] Position
* [`<Number>`] Width
* [`<Number>`] Height
* [`<Number>`] Rotation
* [`<String>`] Text
* [`<Number>`] Shadow
* [`<Number>`] Text size
* [`<String>`] Font
* [`<String>`] Text alignment
* [`<Boolean>`] Draw side arrows
* [`<Code>`] Visibility condition

The code receives the following [`Magic Variables`]:
`_texture`, `_color`, `_position`, `_width`, `_height`, `_angle`, `_text`, `_shadow`, `_textSize`, `_font`, `_align`, `_drawSideArrows`

Example:
```sqf
[
    "ICON",                                                 // Graphics type
    "\a3\ui_f\data\IGUI\Cfg\Actions\clear_empty_ca.paa",    // Path
    [1, 0, 0.1, 1],                                         // Color
    [player, "pilot", [0, 0, 0.45]],                        // Position
    1,                                                      // Width
    1,                                                      // Height
    0,                                                      // Rotation
    name player,                                            // Text
    2,                                                      // Shadow
    0.05,                                                   // Text size
    "PuristaSemiBold",                                      // Font
    "center",                                               // Alignment
    false,                                                  // Side arrows
    {true}                                                  // Visibility
]
```

### Line data

* [`<String>`] Graphics type (should be `"LINE"`)
* [`<3dGraphicsPosition>`] Start position
* [`<3dGraphicsPosition>`] End position
* [`<Color>`] Color
* [`<Code>`] Visibility condition

The code receives the following [`Magic Variables`]:
`_start`, `_end`, `_lineColor`

Example:
```sqf
[
    "LINE",                                                 // Graphics type
    [player, "pilot", [0, 0, 0.45]],                        // Start position
    cursorTarget,                                           // End position
    {true}                                                  // Visibility
]
```

## Graphics position

The graphics position can be given in multiple ways. The easiest is to use the normal [`<Position>`]. 

If you want to attach the graphic to an object, its also possible to pass an [`<Object>`]. If you want to specify a detailed position you can pass an [`<Array>`] in with the following data:
* [`<Object>`] Object
* [`<String>`] Selection
* [`<Position>`] Selection offset (model space)
* [`<Position>`] Position offset (world space)

## CLib_fnc_add3dGraphics

Parameter(s):
* [`<String>`] Identifier
* [`<Array>`] Multiple [`<3dGraphicsData>`]

Returns:
* None

Adds 3d graphic to the system. It can consist of multiple icon and lines.

Examples:
```sqf
["MyIcons", [
    [
        "ICON",                                                 // Graphics type
        "\a3\ui_f\data\IGUI\Cfg\Actions\clear_empty_ca.paa",    // Path
        [1, 0, 0.1, 1],                                         // Color
        [player, "pilot", [0, 0, 0.45]],                        // Position
        1,                                                      // Width
        1,                                                      // Height
        0,                                                      // Rotation
        name player,                                            // Text
        2,                                                      // Shadow
        0.05,                                                   // Text size
        "PuristaSemiBold",                                      // Font
        "center",                                               // Alignment
        false,                                                  // Side arrows
        {true}                                                  // Visibility
    ]
]] call CLib_fnc_add3dGraphics;
```

## CLib_fnc_remove3dGraphics

Parameter(s):
* [`<String>`] Identifier

Returns:
* None

Removes a 3d Graphics group from the system

Examples:
```sqf
["MyIcons"] call CLib_fnc_remove3dGraphics;
```

[`<3dGraphicsData>`]: #graphics_data
[`<3dGraphicsPosition>`]: #graphics_position
[`ICON`]: #icon_data
[`LINE`]: #line_data

[`<Object>`]: https://community.bistudio.com/wiki/Object
[`<Array>`]: https://community.bistudio.com/wiki/Array
[`<Position>`]: https://community.bistudio.com/wiki/Position
[`<String>`]: https://community.bistudio.com/wiki/String
[`<Color>`]: https://community.bistudio.com/wiki/Color
[`<Number>`]: https://community.bistudio.com/wiki/Number
[`<Boolean>`]: https://community.bistudio.com/wiki/Boolean
[`<Code>`]: https://community.bistudio.com/wiki/Code

[`drawIcon3D`]: https://community.bistudio.com/wiki/drawIcon3D
[`drawLine3D`]: https://community.bistudio.com/wiki/drawLine3D

[`Magic Variables`]: https://community.bistudio.com/wiki/Magic_Variables