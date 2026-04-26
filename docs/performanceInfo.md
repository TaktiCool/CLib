# Performance Info

> Maintainer: NetFuison, joko // Jonas

Tools for collecting CLib runtime and performance diagnostics.

## Functions
### CLib_fnc_dumpPerformanceInfo

Parameter(s):
* [`<Object>`] Unit to inspect (default: `objNull`)
* [`<Number>`], [`<Object>`], [`<String>`], [`<Side>`], [`<Group>`], [`<Array>`] Target receiving the dump

Returns:
* None

Dumps CLib performance/debug information and sends the output through CLib events.

Examples:

```sqf
[player, player] call CLib_fnc_dumpPerformanceInfo;
```

[`<Side>`]: https://community.bistudio.com/wiki/Side
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
