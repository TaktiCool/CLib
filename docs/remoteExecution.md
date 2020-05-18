# Remote Execution

> Maintainer: joko // Jonas

The Remote Exec is Meant to be a Fallback system for ServerAdmins that want to Disable vanilla's RemoteExec/RemoteExecCall

## CLib_fnc_remoteExec

Parameter(s):
* [`<Anything>`] Arguments for the function or command
* [`<String>`] Function or command that get executed on the remote clients
* [`<Number>`], [`<Object>`], [`<Side>`], [`<Group>`], [`<Array>`] Target who should receive the event
* [`<Bool>`] Forced to use fallback version

Returns:
* None

Check if the RemoteExecFall Back is used and handle after that the Data and share it to the server

Examples:

```sqf
[nil, "Docs_fnc_DoThingsRemote", 0, true] call CLib_fnc_remoteExec;
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