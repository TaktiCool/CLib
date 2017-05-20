# 3dGraphics

> Maintainer: BadGuy

TODO text here

## CLib_fnc_3dGraphicsPosition

Parameter(s):
* [`<Object>`], [`<Array>`] 3dGraphicsPosition

Returns:
* [`<Position>`] PositionAGL

Converts a 3dGraphicsPosition into PositionAGL

Examples:
```sqf
private _position = [[0, 0, 0]] call CLib_fnc_3dGraphicsPosition;
```

## CLib_fnc_add3dGraphics

Parameter(s):
* [`<String>`] Identifier
* [`<Array>`] Multiple GraphicsData

Returns:
* None

Adds a 3D icon to the system

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

## CLib_fnc_build3dGraphicsCache

## CLib_fnc_draw3dGraphics

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

[`<Object>`]: https://community.bistudio.com/wiki/Object
[`<Array>`]: https://community.bistudio.com/wiki/Array
[`<Position>`]: https://community.bistudio.com/wiki/Position
[`<String>`]: https://community.bistudio.com/wiki/String