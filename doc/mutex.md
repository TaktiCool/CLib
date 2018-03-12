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

[`<Code>`]: https://community.bistudio.com/wiki/Code
[`<Anything>`]: https://community.bistudio.com/wiki/Anything
[`<String>`]: https://community.bistudio.com/wiki/String
