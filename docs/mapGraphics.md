# Map Graphics

> Maintainer: BadGuy

Draw custom map graphics and attach interaction events to map elements.

## Functions
### CLib_fnc_addMapGraphicsEventHandler

Parameter(s):
* [`<String>`] Icon ID
* [`<String>`] Event name
* [`<Code>`], [`<String>`] Handler code
* [`<Anything>`] Custom arguments passed to the handler

Returns:
* [`<Number>`] Event handler ID

Adds an event handler for a map graphics group.

### CLib_fnc_addMapGraphicsGroup

Parameter(s):
* [`<String>`] Group name
* [`<Array>`] Group data
* [`<String>`] State (`normal`, `hover`, `selected`)
* [`<Number>`] Layer

Returns:
* None

Adds or updates a map graphics group with ICON, RECTANGLE, ELLIPSE, LINE, ARROW, POLYGON, or TRIANGLE elements.

### CLib_fnc_buildMapGraphicsCache

Parameter(s):
* None

Returns:
* None

Rebuilds the internal draw cache from registered map graphic groups.

### CLib_fnc_drawMapGraphics

Parameter(s):
* [`<Control>`] Map control

Returns:
* None

Draw callback for registered map controls.

### CLib_fnc_mapGraphicsMouseButtonClick

Parameter(s):
* [`<Array>`] Mouse event arguments
* [`<String>`] Event name (default: `clicked`)

Returns:
* None

Dispatches click-like map mouse events (`clicked`, `down`, `up`) to the nearest map graphic group.

### CLib_fnc_mapGraphicsMouseButtonDblClick

Parameter(s):
* [`<Control>`] Map control
* [`<Number>`] Mouse button
* [`<Number>`] X position
* [`<Number>`] Y position

Returns:
* None

Dispatches double-click events to the nearest map graphic group.

### CLib_fnc_mapGraphicsMouseMoving

Parameter(s):
* [`<Control>`] Map control
* [`<Number>`] X position
* [`<Number>`] Y position

Returns:
* None

Updates hover state and triggers `hoverin` or `hoverout` events.

### CLib_fnc_mapGraphicsPosition

Parameter(s):
* [`<Array>`], [`<Object>`] MapGraphics position value
* [`<Control>`] Map control

Returns:
* [`<Array>`] Position3D

Converts a MapGraphics position descriptor into a world position.

### CLib_fnc_nearestMapGraphicsGroup

Parameter(s):
* [`<Control>`] Map control
* [`<Number>`] X position
* [`<Number>`] Y position

Returns:
* [`<String>`] Group identifier

Gets the nearest map graphics group under the cursor.

### CLib_fnc_registerMapControl

Parameter(s):
* [`<Control>`] Map control

Returns:
* None

Registers a map control and binds all required draw/mouse handlers for Map Graphics.

### CLib_fnc_removeMapGraphicsEventhandler

Parameter(s):
* [`<String>`] Group name
* [`<String>`] Event name
* [`<Number>`] Event ID (`-1` removes all handlers)

Returns:
* None

Removes one or all event handlers for a group and event.

### CLib_fnc_removeMapGraphicsGroup

Parameter(s):
* [`<String>`] Group name

Returns:
* None

Removes a map graphics group and its bound events.

### CLib_fnc_triggerMapGraphicsEvent

Parameter(s):
* [`<String>`] Group name
* [`<String>`] Event name
* [`<Anything>`] Event arguments

Returns:
* None

Triggers handlers for a map graphics group event.

### CLib_fnc_unregisterMapControl

Parameter(s):
* [`<Control>`] Map control

Returns:
* None

Unregisters a map control and removes bound draw/mouse handlers.

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
