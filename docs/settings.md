# Settings

> Maintainer: BadGuy

TODO

## Usage

TODO

## CfgSettings

```csharp
class CfgCLibSettings {
    CLib_test[] = {"CLibSettingsTest"}; // Registers class CLibSettingsTest in Settings System
};
```

## User Settings Class

```csharp
class CLibSettingsTest {
    simpleValueNumber = 1;
    simpleValueText = "This is a Text";
    simpleValueArray[] = {"Element A", "Element B", "Element C"};
    class ComplexSetting {
        value = 1;
        description = "This is a description";
    };

    class ComplexSettingForced {
        value = 1;
        description = "This is a description";
        force = 1;
    };

    class ComplexSettingClient {
        value = 1;
        description = "This is a description";
        client = 0;
    };

    class SubClass {
        simpleValueNumber = 1;
        simpleValueText = "This is a Text";
        simpleValueArray[] = {"Element A", "Element B", "Element C"};
        class ComplexSetting {
            value = 1;
            description = "This is a description";
        };

        class ComplexSettingForced {
            value = 1;
            description = "This is a description";
            force = 1;
        };

        class ComplexSettingClient {
            value = 1;
            description = "This is a description";
            client = 0;
        };
    };
};
```

## Functions

### CLib_fnc_getSetting

Parameter(s):
* [`<String>`] Path
* [`<Array>`], [`<String>`], [`<Number>`] Default

Returns:
* [`<Array>`], [`<String>`], [`<Number>`] Setting Value

Get a settings value

Examples:

```sqf
private _setting = ["CLibSettingsTest/simpleValueNumber", 0] call CLib_fnc_getSetting;
```

### CLib_fnc_getSettings

Parameter(s):
* [`<String>`] Path

Returns:
* [`<Array>`] of strings

Get all settings of a settings-path

Examples:

```sqf
private _allSettings = "CLibSettingsTest" call Clib_fnc_getSettings;
```

### CLib_fnc_getSettingSubClasses

Parameter(s):
* [`<String>`] Path

Returns:
* [`<Array>`] of strings

Get all subclasses of settings-path

Examples:

```sqf
private _allSubSettings = "CLibSettingsTest" call CLib_fnc_getSettingSubClasses;

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
