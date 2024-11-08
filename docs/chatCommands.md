# Config Caching

> Maintainer: joko // Jonas

Adds Ability to Register Chat Commands.


## Functions
### CLib_fnc_registerChatCommand

Parameter(s):
* [`<String>`] Command
* [`<Code>`] Callback
* [`<Anything>`] Arguments <Anything> (default: [])
* [`<Array>`] of [`<String>`] Available For (default: ["all"])
* [`<Array>`] of [`<Number>`] Channels (default: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16])

* [`<Config>`], [`<Array>`] Path to Data
* [`<String>`], [`<Array>`], [`<Number>`] Default Return (optional)
* [`<Boolean>`] Force Type of Default Return (optional)

Returns:
* None

Examples:
```sqf
["setPos", {
    params ["_commandData", "_args", "_messageData"];
    
    player setPos (_commandData apply {parseNumber _x});
    ["Sever", "Position Updated"];
}, ["admin", getPlayerUID player]] call CLib_fnc_registerChatCommand;

// type ""!setPos 0 0 0" to Set the players position to 0,0,0
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
