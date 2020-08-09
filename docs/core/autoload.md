# Autoload

> Maintainer: joko // Jonas, NetFusion

Autoload is the Sub Module that is responsible for the Loading and Transferring process of the Mod Data to the Client.

## Config
```csharp
class CLib {
    TransmissionBlockSize = 3; // The amount of Function the Transmission System Sends Per Tick after the Mission Runs 100 seconds (Default: 3)

    useExperimentalAutoload = 0; // Enables Experimental Autoload System (Default: 0)

    useFallbackRemoteExecution = 0; // Force Enables Fallback Remote Execution system if for Server Owners that disallow remoteExec/remoteExecCall (Default: 0)
    useCompressedFunction = 0; // Enable Compression of Functions that get Transmitted over network currently only Available on Windows (Default: 0)
    Modules[] = {"CLib"}; // Modules CLib Should Load
};
```

## Functions

### CLib_fnc_loadModules

Parameter(s):
* None

Returns:
* None

CLib_fnc_loadModules is the Entry function that is called Once in the Mission init.sqf to initialize CLib

Examples:

```sqf
call CLib_fnc_loadModules;
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
