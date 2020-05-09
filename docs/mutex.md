# Mutex

> Maintainer: NetFusion

The Mutex Module is built around the Idea of Giving Tokens to Clients so that the client can execute code without other clients Interfering with the data the client may modify.


## CLib_fnc_mutex

Parameter(s):
* [`<Code>`] Code
* [`<Anything>`] Arguments
* [`<String>`] Identifier

Returns:
* None

Executes a block of code and prevents it from being partially executed on different clients

Examples:

```sqf
[{
    params ["_myObject"];

    if (_myObject getVariable ["canUse", true]) then {
        _unit setVariable ["canUse", false, true];

        // Do something with _myObject
    };
}, [_myObject], ""] call CLib_fnc_mutex;
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