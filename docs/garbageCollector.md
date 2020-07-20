# Garbage Collector

> Maintainer: joko // Jonas

The GarbageCollector is a Module that Clears WeaponHolder, Dead Vehicle, and Dead Units after a defined amount of Time.
Empty Groups will be deleted Directly after they are empty and not flagged

## Settings
the Settings can get set in the missionConfigFile
```csharp
class CLib {
    class GarbageCollector {
        EnableGarbageCollector = 1;
        GarbageCollectorTime = 120;
        GarbageCollectorLoopTime = 50;
    };
};
```

### EnableGarbageCollector
Boolean if the Garbage Collector is Active

### GarbageCollectorTime
The Time in seconds that a Objects wait in the Queue until its get deleted

### GarbageCollectorLoopTime
The Time the Loops Runs

## Dont Delete a Object or a Group
```sqf
[`<Object>`] setVariable ["CLib_noClean", true];
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
