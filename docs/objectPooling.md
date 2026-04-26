# Object Pooling

> Maintainer: joko // Jonas

Reuse objects and units from pools to avoid repeated creation overhead.

## Functions
### CLib_fnc_getPooledObject

Parameter(s):
* [`<String>`] Object classname
* [`<Number>`] Lock time in seconds after checkout (default: 10)
* [`<Boolean>`] Local object flag (default: true)

Returns:
* [`<Object>`] Pooled object

Gets a pooled object for the given class.

### CLib_fnc_getPooledObjectCondition

Parameter(s):
* [`<String>`] Object classname
* [`<Code>`] Lock condition code (default: `{false}`)
* [`<Boolean>`] Local object flag (default: true)

Returns:
* [`<Object>`] Pooled object

Gets a pooled object using a lock condition callback.

### CLib_fnc_getPooledUnit

Parameter(s):
* [`<String>`] Unit classname
* [`<Code>`] Lock condition code (default: `{false}`)
* [`<Array>`] Unit parameters (default: `[grpNull, {}, 0.5, "PRIVATE"]`)

Returns:
* [`<Object>`] Unit

Gets a pooled unit or creates one if required.

## Unit Parameter Structure
* [`<Group>`] Group
* [`<String>`], [`<Code>`] Init code
* [`<Number>`] Skill
* [`<String>`] Rank

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
