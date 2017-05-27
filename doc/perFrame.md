# PerFrame

> Maintainer: joko // Jonas

TODO text here


## CLib_fnc_addPerframeHandler

Parameter(s):
* [`<Code>`] The Code you wish to execute.
* [`<Number>`] The amount of time in seconds between executions, 0 for every frame.
* [`<Any>`] Parameters passed to the Code executing. This will be the same array every execution

Passed Arguments
* [`<Number>`] current public Perframe Handler ID
* [`<Any>`] Parameters passed by this function. Same as second item from above

Returns:
* [`<Number>`] A number representing the ID of the Handlöer.  Use this to remove the ID.

Add a handler that will execute every frame, or every x number of seconds.

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
* [`<Number>`] The amount of seconds before the code gets executed
* [`<Any>`] Parameters passed to the Code executing

Passed Arguments
* [`<Any>`] Parameters passed by this function. Same as third item from above

Returns:
* None

Executes a code once in unscheduled environment with a given game time delay.

Examples:
```sqf
[{hintSilent format ["This is 10 Seconds Delayed %1", _this]}, 10 ,"Awesome 10s Delay"] call CLib_fnc_wait;
```
## CLib_fnc_waitUntil

Parameter(s):
* [`<Code>`] The Callback Code that gets executed when the Condition is true
* [`<Code>`] The Condition that checks every frame.
* [`<Any>`] Parameters passed to the Code executing. This will be the same array every execution

Passed Arguments
* [`<Any>`] Parameters passed by this function. Same as third item from above

Returns:
* None

Executes a code once in unscheduled environment after a condition is true. Min Delay is 1 Frame.

Examples:
```sqf
[{hintSilent format ["This is Delayed %1", _this]}, {time == 1000 }, "Awesome Delay"] call CLib_fnc_waitUntil;
```

## CLib_fnc_execNextFrame

Parameter(s):
* [`<Code>`] The Code you wish to execute.
* [`<Any>`] Parameters passed to the Code executing. This will be the same array every execution

Passed Arguments
* [`<Any>`] Parameters passed by this function. Same as second item from above

Returns:
* None

Executes a code once in non scheduled environment on the next frame.

Examples:
```sqf
[{hintSilent format ["This is 1 Frame Delayed %1", _this]}, "Awesome 1f Delay"] call CLib_fnc_execNextFrame;
```
## CLib_fnc_skipFrames

Parameter(s):
* [`<Code>`] The Code you wish to execute.
* [`<Number>`] The amount of Frames before the code gets executed
* [`<Any>`] Parameters passed to the Code executing

Passed Arguments
* [`<Any>`] Parameters passed by this function. Same as second item from above

Returns:
* None

Executes a code once in unscheduled environment with a given game Frame delay.
Examples:
```sqf
[{hintSilent format ["This is 10 Frames Delayed %1", _this]}, 10 ,"Awesome 10s Delay"] call CLib_fnc_skipFrames;
```

[`<Object>`]: https://community.bistudio.com/wiki/Object
[`<String>`]: https://community.bistudio.com/wiki/String
[`<Number>`]: https://community.bistudio.com/wiki/Number
[`<Code>`]: https://community.bistudio.com/wiki/Code
[`<Any>`]: https://community.bistudio.com/wiki/Data_Types
