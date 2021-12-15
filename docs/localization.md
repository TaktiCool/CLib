# Localization

> Maintainer: joko // Jonas

A Localization system for the Server Side Nature of the CLib framework. The system Reads Eather from the Stringtable or the [`CfgCLibLocalization`] config class


## CfgCLibLocalization
```sqf
class CLib {
    class TestTranslation { // Translation is accassable as STR_CLib_TestTranslation
        English = "Test English";
        German = "Test German";
        Spanish = "Test Spanish";
        French = "Test French";
        Polish = "Test Polish";
        Czech = "Test Czech";
        Italian = "Test Italian";
        Hungarian = "Test Hungarian";
        Portuguese = "Test Portuguese";
        Russian = "Test Russian";
        Japanese = "Test Japanese";
        Korean = "Test Korean";
        Chinese = "Test Chinese";
        Chinesesimp = "Test simplified Chinese";
    };
};
```

## Functions

### CLib_fnc_formatLocalization

Parameter(s):
* Same Paramter as [format](https://community.bistudio.com/wiki/format)

Returns:
* [`<String>`] Formated and localized string

Format localization wrapper

Examples:

```sqf
[
    "%1 %2 %3 %4",
    "STR_This", "STR_Could", "STR_Be", "STR_Localize"
] call CLib_fnc_formatLocalization
```

### CLib_fnc_isLocalized

Parameter(s):
* [`<String>`] String to Check

Returns:
* [`<Boolean>`] String is Localization Key

Checks of a String is a Localization Key

Examples:

```sqf
TODO Example here
```

### CLib_fnc_readLocalization

Parameter(s):
* [`<String>`] String to Localize

Returns:
* [`<String>`] Localized String

TODO text here

Examples:

```sqf
"STR_LocalizedString" call CLib_fnc_readLocalization
```

[`CfgCLibLocalization`]: #CfgCLibLocalization

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
