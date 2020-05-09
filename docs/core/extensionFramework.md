# Extension Framework

> Maintainer: joko // Jonas, NetFusion

The Extension Frameworks allows to Build your own extensions in C# and let CLib handle the in an output. 
**WARNING! this framework is only functional on windows servers**

## CLib_fnc_callExtension

Parameter(s):
* [`<String>`] Extension name
* [`<String>`] Action name
* [`<Anything>`] Data (optional)
* [`<Code>`] Callback (optional)
* [`<Anything>`] Callback Arguments (optional)

Returns:
* None

Call extension on the server. When the server finished the return value gets passed to the callback as a parameter.

Examples:

```sqf
    ["CLibLogging", "Log", "mylogFile.log:This is My Log Content i want to send over to the extension and in to the file"] call CLib_fnc_callExtension

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
