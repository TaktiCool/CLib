# Per Frame

> Maintainer: joko // Jonas

The PerFrame Module is a Module to improve Writing Code in an unscheduled environment with functions that imitate normal scheduled functions, like sleep, waitUntil and Unlimited Loops that only should run every X Seconds


## CLib_fnc_addPerframeHandler

Parameter(s):
* [`<Code>`] The Code you wish to execute.
* [`<Number>`] The amount of time in seconds between executions, 0 for every frame.
* [`<Anything>`] Parameters passed to the Code executing. This will be the same array every execution

Passed Arguments
* [`<Number>`] current public Perframe Handler ID
* [`<Anything>`] Parameters passed by this function. Same as the second item from above

Returns:
* [`<Number>`] A number representing the ID of the Handlöer.  Use this to remove the ID.

Add a handler that will execute every frame or every x number of seconds.

Examples:
```sqf
private _id = [{hintSilent format ["FRAME! %1", _this]}, 0, ["Awesome", "parameter"]] call CLib_fnc_addPerframeHandler;
```

## CLib_fnc_removePerframeHandler

Parameter(s):
* [`<Number>`] Perframe Handler ID

Returns:
* None

Remove a PFH that you have added using CLib_fnc_addPerframeHandler.

Examples:
```sqf
_id call CLib_fnc_removePerframeHandler;
```

## CLib_fnc_wait

Parameter(s):
* [`<Code>`] The Code you wish to execute.
* [`<Number>`] The number of seconds before the code gets executed
* [`<Anything>`] Parameters passed to the Code executing

Passed Arguments
* [`<Anything>`] Parameters passed by this function. Same as the third item from above

Returns:
* None

Executes a code once in an unscheduled environment with a given game time delay.

Examples:
```sqf
[{hintSilent format ["This is 10 Seconds Delayed %1", _this]}, 10 ,"Awesome 10s Delay"] call CLib_fnc_wait;
```
## CLib_fnc_waitUntil

Parameter(s):
* [`<Code>`] The Callback Code that gets executed when the Condition is true
* [`<Code>`] The Condition that checks every frame.
* [`<Anything>`] Parameters passed to the Code executing. This will be the same array every execution

Passed Arguments
* [`<Anything>`] Parameters passed by this function. Same as the third item from above

Returns:
* None

Executes a code once in the unscheduled environment after a condition is true. Min Delay is 1 Frame.

Examples:
```sqf
[{hintSilent format ["This is Delayed %1", _this]}, {time == 1000}, "Awesome Delay"] call CLib_fnc_waitUntil;
```

## CLib_fnc_execNextFrame

Parameter(s):
* [`<Code>`] The Code you wish to execute.
* [`<Anything>`] Parameters passed to the Code executing. This will be the same array every execution

Passed Arguments
* [`<Anything>`] Parameters passed by this function. Same as the second item from above

Returns:
* None

Executes a code once in an unscheduled environment on the next frame.

Examples:
```sqf
[{hintSilent format ["This is 1 Frame Delayed %1", _this]}, "Awesome 1f Delay"] call CLib_fnc_execNextFrame;
```
## CLib_fnc_skipFrames

Parameter(s):
* [`<Code>`] The Code you wish to execute.
* [`<Number>`] The number of Frames before the code gets executed
* [`<Anything>`] Parameters passed to the Code executing

Passed Arguments
* [`<Anything>`] Parameters passed by this function. Same as the second item from above

Returns:
* None

Executes a code once in an unscheduled environment with a given game Frame delay.
Examples:
```sqf
[{hintSilent format ["This is 10 Frames Delayed %1", _this]}, 10 ,"Awesome 10s Delay"] call CLib_fnc_skipFrames;
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
