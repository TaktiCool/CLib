# Events

> Maintainer: joko // Jonas, NetFusion

The Events Module is Responsible for the Events and Event Methods.
It Contains code for Build in Events and also Custom build Events.

## CLib_fnc_addEventHandler

Parameter(s):
* [`<String>`] Event ID
* [`<Code>`], [`<String>`] Event Function Code
* [`<Anything>`] Event Arguments

Returns:
* [`<Number>`] the ID of the Current Eventhandler

In the Code you can Access the Event call parameter via  `_this select 0;` and the Event Arguments via `_this select 1;`

Examples:

```sqf
["myAwsomeEvent", {
    hint "this is my Awesome Event";
}] call CLib_fnc_addEventHandler;
```

## CLib_fnc_addIgnoredEventLog

Parameter(s):
* [`<String>`] Name
* [`<Number>`] Ignore type (0 = dont Log anything, 1 = dont log the Aruments)

Returns:
* None

Adds events that do not get logged

Examples:

```sqf
["myAwsomeEvent2", 1] call CLib_fnc_addIgnoredEventLog;
["myAwsomeEvent3", 0] call CLib_fnc_addIgnoredEventLog;
```

## CLib_fnc_globalEvent

Parameter(s):
* [`<String>`] Event name
* [`<Anything>`] Arguments (Optional)
* [`<String>`], [`<Number >`] Persistent (Optional)

Returns:
* None

Trigger a event on every machine that is connected

Examples:

```sqf
"myAwsomeEvent" call CLib_fnc_globalEvent;
```

## CLib_fnc_invokePlayerChanged

Parameter(s):
* [`<Object>`] New Player Object

Returns:
* None

Invokes Scripted player Change

Examples:

```sqf
private _tempGroup = createGroup east;
private _newUnit = _tempGroup createUnit ["O_Soldier_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
selectPlayer _newUnit;
_newUnit call CLib_fnc_invokePlayerChanged;
```

## CLib_fnc_localEvent

Parameter(s):
* [`<String>`] Event name
* [`<Anything>`] Arguments (Optional)

Returns:
* [`<Anything>`] Return of Last set on `_CLib_EventReturn`

Triggers a Event on the Local Client

Examples:

```sqf
"myAwsomeEvent" call CLib_fnc_localEvent;
```

## CLib_fnc_serverEvent

Parameter(s):
* [`<String>`] Event name
* [`<Anything>`] Arguments (Optional)

Returns:
* None

Trigger an event on the server

Examples:

```sqf
"myAwsomeEvent" call CLib_fnc_serverEvent;
```

## CLib_fnc_targetEvent

Parameter(s):
* [`<String>`] Event name
* [`<Object>`], [`<Number>`], [`<String>`], [`<Array>`] Targets
* [`<Anything>`] Arguments (Optional)

Returns:
* None

Trigger Event on a Target Client

Examples:

```sqf
["myAwsomeEvent", [cursorTarget, 2, 1337]] call CLib_fnc_targetEvent;
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
