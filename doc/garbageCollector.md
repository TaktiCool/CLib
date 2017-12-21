# GarbageCollector

> Maintainer: joko // Jonas

The GarbageCollector is a Module that Clears WeaponHolder, Dead Vehicle, and Dead Units after a defined amount of Time.
Empty Groups will be deleted Directly after they are empty and not flagged


## Settings
the Settings can get set in the missionConfigFile
```sqf
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
[`<Object>`]: https://community.bistudio.com/wiki/Object
