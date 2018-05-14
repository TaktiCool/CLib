# Events

> Maintainer: joko // Jonas, NetFusion

TODO text here

## AllGearData
* [`<String>`] Headgear
* [`<String>`] Googgles
* [`<String>`] Uniform
* [`<Array>`] of [`<String>`] Uniform Items
* [`<String>`] Vest
* [`<Array>`] of [`<String>`] Vest Items
* [`<String>`] Backpack
* [`<Array>`] of [`<String>`] Backpack Items
* [`<String>`] Rifle
* [`<Array>`] of [`<String>`] Rifle Items
* [`<Array>`] of [`<String>`] Rifle Magazine
* [`<String>`] Launcher
* [`<Array>`] of [`<String>`] Launcher Items
* [`<Array>`] of [`<String>`] Launcher Magazines
* [`<String>`] Handgun
* [`<Array>`] of [`<String>`] Handgun Items
* [`<Array>`] of [`<String>`] Handgun Magazines
* [`<Array>`] of [`<String>`] Assigned Items
* [`<String>`] Binoculars

## CLib_fnc_addContainer

Parameter(s):
* [`<Object>`] Unit
* [`<String>`] Container Classname
* [`<Number>`] Container Type (Default: -1)

Returns:
* None

Add Container Wrapper

Examples:

```sqf
TODO Example here
```

## CLib_fnc_addItem

### ItemData
* [`<String>`] Item Classname
* [`<Number>`] Amount of Items get Added

or

* [`<String>`] Item Classname

Parameter(s):
* [`<Object>`] Unit
* [`<ItemData>`], [`<String>`] Item Data or Classname

Returns:
* None

Add item Wraper

Examples:

```sqf
TODO Example here
```

## CLib_fnc_addMagazine

### MagazineData
* [`<String>`] or [`<MagData>`] Magazine Classname
* [`<Number>`] Amount of Magazines get Added

or

* [`<String>`] Item Classname

### MagData
* [`<String>`] Item Classname
* [`<Number>`] Amount of Bullets in the Magazine  

or  

* [`<String>`] Item Classname

Parameter(s):
* [`<Object>`] Unit
* [`<MagazineData>`], [`<String>`] Magazine

Returns:
* None

Add magazine Wraper

Examples:

```sqf
TODO Example here
```

## CLib_fnc_addWeapon

Parameter(s):
* [`<Object>`] Unit
* [`<String>`] Weapon Classname
* [`<MagazineData>`], [`<String>`] Magazine Data

Returns:
* None

Add weapon Wraper

Examples:

```sqf
TODO Example here
```

## CLib_fnc_copyGear

Parameter(s):
* [`<Object>`] Source Unit
* [`<Object>`] Destination Unit

Returns:
* None

Copies gear from source unit to destination

Examples:

```sqf
TODO Example here
```

## CLib_fnc_getAllGear

Parameter(s):
* [`<Object>`] Unit

Returns:
* [`<AllGearData>`] AllGear Data

Returns an array containing all items of a given unit

Examples:

```sqf
TODO Example here
```

## CLib_fnc_restoreGear

### RestoreGearData
* [`<AllGearData>`] AllGearData
* [`<magazinesAmmoFull>`] magazinesAmmoFull Return

Parameter(s):
* [`<Object>`] Unit
* [`<RestoreGearData>`] Restore Gear Data

Returns:
* None

Restore gear from saveGear Function to Unit

Examples:

```sqf
TODO Example here
```

## CLib_fnc_saveGear

Parameter(s):
* [`<Object>`] Unit

Returns:
* [`<RestoreGearData>`] Restore Gear Data

Save Gear

Examples:

```sqf
TODO Example here
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
[`<magazinesAmmoFull>`]: https://community.bistudio.com/wiki/magazinesAmmoFull
[`<ItemData>`]: #ItemData
[`<MagData>`]: #MagData
[`<MagazineData>`]: #MagazineData
[`<AllGearData>`]: #AllGearData
[`<RestoreGearData>`]: #RestoreGearData
