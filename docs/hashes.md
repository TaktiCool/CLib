# Hashes

> Maintainer: joko // Jonas

The Hashes Modules is a Module to handle Hash Arrays.


## Data Types

### HashSet
Hash Sets are Array of Array of Any Data
* [`<Array>`] Array of Keys
* [`<Array>`] Array of Values

## Functions

### CLib_fnc_containsKey

Parameter(s):
* [`<HashSet>`] The HashSet to Check in
* [`<Anything>`] The Key to Check for

Returns:
* [`<Boolean>`] Found the Searched Key

Checks if a Hashset Contains a Key

Examples:

```sqf
TODO Example here
```

### CLib_fnc_containsValue

Parameter(s):
* [`<HashSet>`] The HashSet to Check in
* [`<Anything>`] The Valude to Check for

Returns:
* [`<Boolean>`] Found the Searched Valude

Checks if a Hashset Contains a Value

Examples:

```sqf
TODO Example here
```

### CLib_fnc_countHash

Parameter(s):
* [`<HashSet>`] The HashSet to Count

Returns:
* [`<Number>`] Amount of Hashes in Hashset

Counts amount of Hashes in Hash set

Examples:

```sqf
TODO Example here
```

### CLib_fnc_createHash

Parameter(s):
None

Returns:
* [`<HashSet>`] New HashSet

Creates a New Hashset

Examples:

```sqf
MyAwsomeHashSet = call CLib_fnc_createHash;
```

### CLib_fnc_forEachHash

Parameter(s):
* [`<HashSet>`] HashSet to Loop through
* [`<Code>`] Code to Execute on every Item of the HashSet
* [`<Anything>`] Arguments that gets Passed to the Code

Returns:
* None

Loops though all Entrys in a HashSet

Examples:

```sqf
TODO Example here
```

### CLib_fnc_getHash

Parameter(s):
* [`<HashSet>`] HashSet to get Value from
* [`<Anything>`] Key to get from [`HashSet`]

Returns:
* [`<Anything>`] Value from HashSet

Get a Value from the Hashset

Examples:

```sqf
private _isBanana = [MyAwsomeHashSet, "isbanana"] call CLib_fnc_getHash;
```

### CLib_fnc_hashKeys

Parameter(s):
* [`<HashSet>`] HashSet to get all keys from

Returns:
* [`<Array>`] all keys from the HashSet

Gets all Keys from a HashSet

Examples:

```sqf
private _keys = [MyAwsomeHashSet] call CLib_fnc_hashKeys;
```

### CLib_fnc_hashToNamespace

Parameter(s):
* [`<Namespace>`], [`<Location>`], [`<Object>`], [`<Group>`] Namespace
* [`<HashSet>`] HashSet
* [`<Boolean>`] Publish Variables
* [`<String>`] AllVarNames Cache Name

Returns:
* None

Converts a HashSet into a Namespace

Examples:

```sqf
[MyNewNamespace, MyAwsomeHashSet, true, "AllVariables"] call CLib_fnc_hashToNamespace
```

### CLib_fnc_hashValues

Parameter(s):
* [`<HashSet>`] HashSet to get Value from

Returns:
* [`<Array>`] All Values from the HashSet

Gets all Values from a HashSet

Examples:

```sqf
private _keys = [MyAwsomeHashSet] call CLib_fnc_hashKeys;
```

### CLib_fnc_hashToTuple

Parameter(s):
* [`<HashSet>`] HashSet

Returns:
* [`<Array>`] Tuple Array representation of the HashSet

Tuple Array representation of the HashSet

Examples:

```sqf
private _keys = [MyAwsomeHashSet] call CLib_fnc_hashToTuple;
```

### CLib_fnc_isHash

Parameter(s):
* [`<HashSet>`] HashSet to get Value from

Returns:
* [`<Boolean>`] Array is a Hashset

Checks if Array is a Hashset

Examples:

```sqf
private _keys = [MyAwsomeHashSet] call CLib_fnc_hashKeys;
```

### CLib_fnc_namespaceToHash

Parameter(s):
* [`<Namespace>`], [`<Location>`], [`<Object>`], [`<Group>`] Namespace
* [`<HashSet>`] HashSet
* [`<String>`] AllVarNames Cache Name

Returns:
* [`<HashSet>`] the HashSet

Converts a Namespace into a HashSet

Examples:

```sqf
[MyNewNamespace, MyAwsomeHashSet, "AllVariables"] call CLib_fnc_namespaceToHash
```

### CLib_fnc_setHash

Parameter(s):
* [`<HashSet>`] HashSet
* [`<Anything>`] Key
* [`<Anything>`] Value

Returns:
* [`<Array>`] HashSet

Sets a Hash Value to a Key in a Hashlist

Examples:

```sqf
[MyAwsomeHashSet, "isbanana", true] call CLib_fnc_getHash;
```

[`<HashSet>`]: #HashSet
[`HashSet`]: #HashSet

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
