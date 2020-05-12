# Misc

> Maintainer: joko // Jonas, NetFusion

The Misc Module is a Core Sub Module with various functions that don't fit in any other Module or are to small for there own Module.


## CLib_fnc_blurScreen

Parameter(s):
* [`<Number>`] ID
* [`<Boolean>`], [`<Number>`] Show?

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
* [`<Number>`] Time until the cached values are being obsolete
* [`<String>`] Event that clears the cache

Returns:
* [`<Anything>`] Return of the Cached Function

Calls a function and Caches the Return for a certain amount of time or until a clear Event is called

Examples:
```sqf
[
    "Am_I_Dead",
    {alive _this},
    CLib_player,
    5,
    "I_Know_That_I_Am_Dead"
] call CLib_fnc_cachedCall;
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

## CLib_fnc_compatibleMagazines

Parameter(s):
* [`<String>`] Weapon Name
* [`<String>`] Muzzle Name

Returns:
* [`<Array>`] of [`<String>`] List of all Compatible Magazines of a Weapons Muzzle

Returns a Array of All Compatible Magazines for Weapon/Muzzle

Examples:
```sqf
private _compatibleMagazines = (primaryWeapon player) call CLib_fnc_compatibleMagazines
```

## CLib_fnc_compileFinal

Parameter(s):
* [`<Code>`] Code to Compile Final
* [`<String>`] Variable Name

Returns:
* [`<Code>`] Final Compiled Code

Compiles a Function Final and Saves them in a namespace
if Variable Name is not set it will only return the function as Final Compiled Code

Examples:
```sqf
MY_fnc_Function = {hint "Compiled Final Function"} call CLib_fnc_compileFinal;

// Alt Syntax
[{hint "Compiled Final Function"}, "MY_fnc_Function"] call CLib_fnc_compileFinal;

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

Calls a function directly and changes the Environment to Unscheduled

Examples:
```sqf
{hint "this Runs in a Unscheduled Environment"} call CLib_fnc_directCall;
```

## CLib_fnc_disabledUserInput

Parameter(s):
* [`<Boolean>`] True to disable key inputs, false to re-enable them

Returns:
* None

Disables key input. ESC can still be pressed to open the menu.

Examples:
```sqf
true call CLib_fnc_disabledUserInput;

[{ false call CLib_fnc_disabledUserInput; }, 10] CLib_fnc_wait;
```

## CLib_fnc_fileExist

Parameter(s):
* [`<String>`] File Path with Filename

Returns:
* [`<Boolean>`] File exist?

Very dirty solution to check if a file exists. Every file type need to be added at allowedHTMLLoadExtensions in the server config file.

Examples:
```sqf
private _exists = "image.paa" call CLib_fnc_fileExist
```

## CLib_fnc_findSavePosition

Parameter(s):
* [`<Position>`] Position
* [`<Number>`] Radius
* [`<Number>`] Minimal Radius (Default: 0)
* [`<String>`] Vehicle Class (Default: Nil)

Returns:
* [`<Position>`] Save Position

This function is a failsafe wrapper function for findEmptyPosition.
Finds a save position for a unit. This function always returns a position.

Examples:

```sqf
private _pos = [getPos player, 100, 5, "B_Truck_F"] call CLib_fnc_findSavePosition;
```

## CLib_fnc_fixFloating

Parameter(s):
* [`<Object>`] Object to Fix

Returns:
* None

Attempt to fix floating physix with disabled damage after setPosXXX commands.
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

This function fixes an issue occurring when using str on a config without appending the complete file path

Examples:

```sqf
[configFile >> "TestConfig" >> "andMoreTest", ">>"] call CLib_fnc_flatConfigPath;
```

## CLib_fnc_getFOV

Parameter(s):
* None

Returns:
* [`<Number>`] Current FOV/Focal Length

Calculate Current FOV and Zoom

Examples:

```sqf
private _currentFOV = call CLib_fnc_getFOV;
```

## CLib_fnc_getNearUnits

Parameter(s):
* [`<Position>`], [`<Object>`] Position
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
private _pos = (group player) call CLib_fnc_getPos;
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
* [`<Number>`] Size of Target Position/Target

Returns:
* [`<Boolean>`] In FOV

checks if a Position is in FOV of a Object

Examples:

```sqf
private _inVew = [CLib_Player, _target, 1.55] call CLib_fnc_inFOV;
```

## CLib_fnc_isKindOfArray

Parameter(s):
* [`<Object>`], [`<String>`] Target Kind
* [`<Array>`] of [`<String>`] Possible Kinds

Returns:
* [`<Boolean>`] is Kind Of Target Kind

is Kind Of Array

Examples:

```sqf
private _isKindOf = [
    vehicle CLib_Player,
    ["Air", "Tank", "Wheeled_APC_F"]
] call CLib_fnc_isKindOfArray;
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
* [`<String>`, `<Text>`] Text
* [`<String>`] Header
* [`<Code>`, `Array>`] Button 1 Callback
* [`<Code>`, `<Array>`] Button 2 Callback
* [`<Code>`] onClose
* [`<Anything>`] Arguments

Returns:
* None

Creates a two-option message box in a new dialogue.

Examples:

```sqf
TODO Example here
```

## CLib_fnc_modLoaded

Parameter(s):
* [`<String>`] Mod Name

Returns:
* [`<Boolean>`] Mod is Loaded

Checks if a Mod or Parts of it are Loaded

Examples:

```sqf
["Streamator"] call CLib_fnc_moduleLoaded;
```

## CLib_fnc_moduleLoaded

Parameter(s):
* [`<String>`] Module Name

Returns:
* [`<Boolean>`] Module is Loaded

Checks if a Module is Loaded

Examples:

```sqf
["CLib/PerFrame"] call CLib_fnc_moduleLoaded;
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

## CLib_fnc_registerEntryPoint

Parameter(s):
* [`<Code>`] Code To Execute when CLib is Loaded
* [`<Anything>`] Arguments that get passed to Code

Returns:
* None

Function that allows to execute code from the mission direct without using Mission Modules.

Examples:

```sqf
[{
    hintSilent "When this Code runs Every CLib function is Avaliable";
}, "Arguments"] call CLib_fnc_registerEntryPoint;
```

## CLib_fnc_sanitizeString

Parameter(s):
* [`<String>`] The string to sanitize

Returns:
* [`<String>`] The sanitized string

Removes all special characters from a string that could be displayed in a weird way or cause other problems

Examples:
```sqf
["<Docs>ItsDocs"] call ace_common_fnc_sanitizeString;
```

## CLib_fnc_setVariablePublic

Parameter(s):
* [`<Object>`] Object the variable should be assigned to
* [`<String>`] Name of the variable
* [`<Anything>`] Value of the variable
* [`<Number>`] Embargo delay (Default: 1)

Returns:
* None

Publish a variable but wait a certain amount of time before allowing it to be published it again.

Examples:
```sqf
[CLib_Player, "TestVariable", str (random 1000), 5] call CLib_fnc_setVariablePublic;
```

## CLib_fnc_shuffleArray

Parameter(s):
* [`<Array>`] Unshuffled Array

Returns:
* [`<Array>`] Shuffled Array

Returns a shuffled array.

Examples:
```sqf
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10] call CLib_fnc_shuffleArray;
```

## CLib_fnc_textTile

Parameter(s):
* [`<String>`], [`<Structured Text>`] Content
* [`<Array>`], [`<Boolean>`] Position (Default: [0, 0, 1, 1])
* [`<Number>`], [`<Array>`] Size (Default: 10)
* [`<Number>`] Duration (Default: 5)
* [`<Array>`], [`<Number>`] Fade Times (Default: [0.5, 0.5])
* [`<Number>`] Max Alpha (Default: 0.3)

Returns:
* None

Show animated text

Examples:

```sqf
[
    parseText "<img size='15' color='#ffffff' shadow='false' image='images\Logo.paa'/>",
    [0.1,0.2,1,0.5],
    [10,3],
    3,
    3,
    0
] call CLib_fnc_textTiles;

```

## CLib_fnc_toFixedNumber

Parameter(s):
* [`<Number>`] Number

Returns:
* [`<String>`] Number in a String form

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
[`<Group>`]: https://community.bistudio.com/wiki/Group
[`<Location>`]: https://community.bistudio.com/wiki/Location
[`<Structured Text>`]: https://community.bistudio.com/wiki/Structured_Text
[`<Waypoint>`]: https://community.bistudio.com/wiki/Waypoint
[`<Task>`]: https://community.bistudio.com/wiki/Task
