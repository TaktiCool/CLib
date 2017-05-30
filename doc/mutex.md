# Mutex

> Maintainer: NetFusion

TODO text here


## CLib_fnc_mutex

Parameter(s):
* [`<Code>`] Code
* [`<Array>`] Arguments
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

[`<Code>`]: https://community.bistudio.com/wiki/Code
[`<Array>`]: https://community.bistudio.com/wiki/Array
[`<String>`]: https://community.bistudio.com/wiki/String
