# Compression

> Maintainer: joko // Jonas, NetFusion, Badguy

> [!DANGER]
> This Module is only functional on windows servers

Compression is a Module that is responsible for the ability to Compress and Decompress String to reduce Network traffic.

## Functions
### CLib_fnc_compressString

Parameter(s):
* [`<String>`] String to Compress

Returns:
* [`<String>`] Compressed String

> [!DANGER]
> Function only Available on Servers and Only Functional on Windows Server

> [!TIP]
> When Function Returns A Empty String or a ACK(acknowledge, Char Code 6)
Compresses a String

Examples:
```sqf
private _compressedString = "String to Compresses that is Big" call CLib_fnc_compressString;
```
### CLib_fnc_decompressString

Parameter(s):
* [`<String>`] String to Compress

Returns:
* [`<String>`] Compressed String

> [!NOTE]
> Function is Available on Every client and Server

Compresses a String

Examples:
```sqf
private _decompressedString = _compressedString call CLib_fnc_decompressString;
```
[`<Control>`]: https://community.bistudio.com/wiki/Control
[`<Anything>`]: https://community.bistudio.com/wiki/Anything
[`<Config>`]: https://community.bistudio.com/wiki/Config
[`<Object>`]: https://community.bistudio.com/wiki/Object
[`<String>`]: https://community.bistudio.com/wiki/String
[`<Number>`]: https://community.bistudio.com/wiki/Number
[`<Array>`]: https://community.bistudio.com/wiki/Array
[`<Position>`]: https://community.bistudio.com/wiki/Position
[`<Color>`]: https://community.bistudio.com/wiki/Color
[`<Boolean>`]: https://community.bistudio.com/wiki/Boolean
[`<Code>`]: https://community.bistudio.com/wiki/Code
[`<Group>`]: https://community.bistudio.com/wiki/Group
[`<Location>`]: https://community.bistudio.com/wiki/Location
[`<Structured Text>`]: https://community.bistudio.com/wiki/Structured_Text
[`<Waypoint>`]: https://community.bistudio.com/wiki/Waypoint
[`<Task>`]: https://community.bistudio.com/wiki/Task
