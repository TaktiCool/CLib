# Notification

> Maintainer: BadGuy, joko // Jonas

Display CLib notifications and hints on registered displays.

## Functions
### CLib_fnc_displayNotification

Parameter(s):
* [`<String>`], [`<Array>`] Header text
* [`<String>`], [`<Array>`] Description text
* [`<Array>`] Icon stack
* [`<Boolean>`], [`<String>`], [`<Array>`] Sound configuration

Returns:
* None

Displays a timed notification entry.

### CLib_fnc_displayHint

Parameter(s):
* [`<String>`], [`<Array>`] Header text
* [`<String>`], [`<Array>`] Description text
* [`<Array>`] Icon stack
* [`<Boolean>`], [`<String>`], [`<Array>`] Sound configuration

Returns:
* None

Displays a short hint overlay.

### CLib_fnc_registerDisplayNotification

Parameter(s):
* [`<Display>`] Display to register
* [`<Array>`] Notification offset
* [`<Array>`] Hint offset

Returns:
* None

Registers a display for notification and hint rendering.

[`<Display>`]: https://community.bistudio.com/wiki/display
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
