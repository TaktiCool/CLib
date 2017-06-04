# Namespace

> Maintainer: joko // Jonas

TODO text here


## CLib_fnc_createNamespace

Parameter(s):
* [`<Boolean>`] Namespace is Global

Returns:
* [`<Object>`], [`<Location>`] Namespace

Create a Local or Global Namespace

Examples:

```sqf

```

## CLib_fnc_deleteNamespace

Parameter(s):
* [`<Object>`], [`<Location>`] Namespace

Returns:
* None

Delete a Local or Global Namespace that was created with CLib_fnc_createNamespace

Examples:

```sqf

```

## CLib_fnc_getLogicGroup
DEPRECATED FUCNTION

## CLib_fnc_getVariable
DEPRECATED FUCNTION

## CLib_fnc_setVar
DEPRECATED FUCNTION

## CLib_fnc_setVariable

Parameter(s):
* [`<Object>`], [`<Location>`] Namespace
* [`<String>`] Variable Name
* [`<Any>`] Data
* [`<String>`] Cache name
* [`<Boolean>`] Global

Returns:
* None

Sets a Varaible on a Object/Namespace and also saves the Varaible Name in a Array on this Namespace for later use

Examples:

```sqf

```

## CLib_fnc_allVariable

Parameter(s):
* [`<Object>`], [`<Location>`] Namespace
* [`<String>`] Variable Name
* [`<String>`] Cache name

Returns:
* [`<Array>`] Array with all Variable Names that where set with CLib_fnc_setVariable

Sets a Varaible on a Object/Namespace and also saves the Varaible Name in a Array on this Namespace for later use

Examples:

```sqf

```

[`<Control>`]: https://community.bistudio.com/wiki/Control
[`<Any>`]: https://community.bistudio.com/wiki/Data_Types
[`<Config>`]: https://community.bistudio.com/wiki/Config
[`<Object>`]: https://community.bistudio.com/wiki/Object
[`<String>`]: https://community.bistudio.com/wiki/String
[`<Number>`]: https://community.bistudio.com/wiki/Number
[`<Array>`]: https://community.bistudio.com/wiki/Array
[`<Position>`]: https://community.bistudio.com/wiki/Position
[`<Color>`]: https://community.bistudio.com/wiki/Color
[`<Boolean>`]: https://community.bistudio.com/wiki/Boolean
[`<Code>`]: https://community.bistudio.com/wiki/Code
[`<Location>`]: https://community.bistudio.com/wiki/Location
