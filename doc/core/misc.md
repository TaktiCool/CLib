# Events

> Maintainer: joko // Jonas, NetFusion

The Misc Module is a Core Sub Module with various functions that don't fit in any other Module or are to small for there own Module.


## CLib_fnc_blurScreen

Parameter(s):
* [`<Number>`] ID
* [`<Boolean>`, `<Number>`] Show?

Returns:
* None

Blurs the Players Screen

Examples:

```sqf
[1337, true] call CLib_fnc_blurScreen;
```

## CLib_fnc_cachedCall

Parameter(s):
* [`<String>`] Cache ID
* [`<Code>`] Function whose return value gets cached
* [`<Anything>`] Arguments
* [`<Number>`] Time until the cached values are being obsolet
* [`<String>`] Event that clears the cache

Returns:
* [`<Anything>`] Return of the Cached Function

Calls a function and Caches the Return for a certain amount of time or until a clear Event is called

Examples:

```sqf
["Am_I_Dead", {alive _this}, CLib_player, 5, "I_Know_That_I_Am_Dead"] call CLib_fnc_cachedCall;
```

## CLib_fnc_codeToString

Parameter(s):
* [`<Code>`] Code to convert

Returns:
* [`<String>`] Code as String

Converts the given code to a string which is needed for some EventHandler

Examples:

```sqf
{hint "this is Needed for some Eventhandler!";} call CLib_fnc_codeToString;
```

## CLib_fnc_createPPEffect

Parameter(s):
* [`<String>`] Determines which kind of effect is created
* [`<Number>`] On which layer should the effect be visible
* [`<Array>`] The initial parameters for the effect

Returns:
* [`<Number>`] A handle for the created effect

This function creates an post processor effect.

Examples:

```sqf
TODO Example here
```

## CLib_fnc_deleteAtEntry

Parameter(s):
* [`<Array>`] Array reference
* [`<Anything>`] Entry to delete
* [`<Boolean>`] Delete every entry

Returns:
* [`<Array>`] Deleted Index [`<Number>`]

Deletes an entry out of an array
This function works with the given reference!

Examples:

```sqf
TODO Example here
```

## CLib_fnc_directCall

Parameter(s):
* [`<Code>`] Code or Function that gets called
* [`<Anything>`] Arguments

Returns:
* [`<Anything>`] Return of the Function

Calls a funcion directly and changes the Environment to Unscheduled

Examples:

```sqf
{hint "this Runs in a Unscheduled Environment"} call CLib_fnc_directCall;
```

## CLib_fnc_disabledUserInput

Parameter(s):
* [`<Type>`] TODO text here

Returns:
* [`<Boolean>`] True to disable key inputs, false to re-enable them

Disables key input. ESC can still be pressed to open the menu.

Examples:

```sqf
true call CLib_fnc_disabledUserInput;
```

## CLib_fnc_fileExist

Parameter(s):
* [`<String>`] File Path with Filename

Returns:
* [`<Boolean>`] File exist?

Very dirty solution to check if a file exists. Every file type need to be added at allowedHTMLLoadExtensions in the server config file.

Examples:

```sqf
TODO Example here
```

## CLib_fnc_findSavePosition

Parameter(s):
* [`<Position>`] Position
* [`<Number>`] Radius
* [`<Number>`] Minimal Radius (Default: 0)
* [`<String>`] Vehicle Class (Default: Nil)

Returns:
* [`<Position>`] Save Position

This function is a failsave wrapper function for findEmptyPosition.
Finds a save postion for a unit. This function always returns a position.

Examples:

```sqf
private _spawnPos = [getPos CLib_Player, 100, 5, "B_Truck_01_mover_F"] call CLib_fnc_findSavePosition;
```

## CLib_fnc_fixFloating

Parameter(s):
* [`<Object>`] Object to Fix

Returns:
* None

Attempt to fix floating physx with disabled damage after setPosXXX commands.
Handles the fixFloating event

Examples:

```sqf
CLib_player call CLib_fnc_fixFloating;
```

## CLib_fnc_fixPosition

Parameter(s):
* [`<Object>`] Object to Fix

Returns:
* None

Fixes position of an object. Moves object above ground and adjusts to terrain slope. Requires local object.

Examples:

```sqf
CarryCrate call CLib_fnc_fixPosition;
```

## CLib_fnc_flatConfigPath

Parameter(s):
* [`<Config>`] Config Path
* [`<String>`] Seperator (Default: "/")

Returns:
* [`<String>`] Path in a String from

This function fixes an issue occuring when using str on a config without appending the complete file path

Examples:

```sqf
[configFile >> "TestConfig" >> "andMoreTest", ">>"] call CLib_fnc_flatConfigPath;
```

## CLib_fnc_getFOV

Parameter(s):
* None

Returns:
* [`<Number>`] Current FOV/Focal Lenth

Calculate Current FOV and Zoom

Examples:

```sqf
private _currentFOV = call CLib_fnc_getFOV;
```

## CLib_fnc_getNearUnits

Parameter(s):
* [`<Postion>`], [`<Object>`] Position
* [`<Number>`] Radius

Returns:
* [`<Array>`] All near Units [`<Object>`]

Gets all near units. Includes units in vehicles.
This Function is Cached with a 2 sec update time!
The Cache can be reset with the Event CLib_clearUnits
Examples:

```sqf
{_x setDamage 1} forEach [CLib_player, 100] call CLib_fnc_getNearUnits;
```

## CLib_fnc_getPos

Parameter(s):
* [`<String>`], [`<Object>`], [`<Position>`] Position Data

Returns:
* [`<Position>`] Position

Wrapper for getPos if you are not sure if you get an object array or string

Examples:

```sqf
TODO Example here
```

## CLib_fnc_groupPlayers

Parameter(s):
* [`<Object>`], [`<Group>`] Group or Unit with Players in

Returns:
* [`<Array>`] Array of Players in Group [`<Object>`]

Gets all players of a group. Comparable to units command.

Examples:

```sqf
private _allGroupPlayers = CLib_Player call CLib_fnc_groupPlayers;
```

## CLib_fnc_inFOV

Parameter(s):
* [`<Position>`] Seeker Object
* [`<Position>`], [`<Object>`] Target Position or Object
* [`<Number >`] Size of Target Position/Target

Returns:
* [`<Boolean>`] In FOV

checks if a Position is in FOV of a Object

Examples:

```sqf
TODO Example here
```

## CLib_fnc_isKindOfArray

Parameter(s):
https://community.bistudio.com/wiki/isKindOf
exept that 2nd Parameter is a Array with Multible Types/Checks Posible

Returns:
* [`<Boolean>`] is Kind Of Input1

is Kind Of Array

Examples:

```sqf
TODO Example here
```

## CLib_fnc_isSpeaking

Parameter(s):
* [`<Object>`] Object to Check

Returns:
* [`<Boolean>`] is Speaking

checks if player is speaking works with TFAR, ACRE2 and Vanilla In Game Voice

Examples:

```sqf
private _isSpeaking = cursorTarget call CLib_fnc_isSpeaking;
```

## CLib_fnc_log

This Function Should not be called by hand. use DUMP or LOG Macro for that!

## CLib_fnc_modLoaded

Parameter(s):
* [`<String>`] Mod Name

Returns:
* [`<Boolean>`] Mod is Loaded

Checks if a Mod or Parts of it are Loaded

Examples:

```sqf
TODO Example here
```

## CLib_fnc_moduleLoaded

Parameter(s):
* [`<String>`] Module Name

Returns:
* [`<Boolean>`] Module is Loaded

Checks if a Module is Loaded

Examples:

```sqf
TODO Example here
```

## CLib_fnc_name

Parameter(s):
* [`<Object>`] Object whose name will be detected

Returns:
* [`<String>`] Name of the Object

Gets a Object Name or displayName.

Examples:

```sqf
CLib_Player call CLib_fnc_name;
```

## CLib_fnc_sanitizeString

Parameter(s):
* [`<String>`] The string to sanitize

Returns:
* [`<String>`] The sanitized string

Removes all special characters from a string that could be displayed in a weird way or cause other problems

Examples:

```sqf
TODO Example here
```

## CLib_fnc_setVariablePublic

Parameter(s):
* [`<Object>`] Object the variable should be assigned to
* [`<String>`] Name of the variable
* [`<Anything>`] Value of the variable
* [`<Number>`] Embargo delay (Optional. Default: 1)

Returns:
* None

Publish a variable but wait a certain amount of time before allowing it to be published it again.

Examples:

```sqf
[CLib_Player, "TestVariable", str (random 1000), 5] call CLib_fnc_setVariablePublic;
```

## CLib_fnc_shufffleArray

Parameter(s):
* [`<Array>`] Unshuffled Array

Returns:
* [`<Array>`] Shuffled Array

Returns a shuffled array.

Examples:

```sqf
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10] call CLib_fnc_shufffleArray;
```

## CLib_fnc_toFixedNumber

Parameter(s):
* [`<Number>`] Number

Returns:
* [`<Type>`] Number in a String form

Removes all Not needed 0 from toFixed numbers and returls only the max toFixed number count that is required.

Examples:

```sqf
private _strNumber = (10/3) call CLib_fnc_toFixedNumber;
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
