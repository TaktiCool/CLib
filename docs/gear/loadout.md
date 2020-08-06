# Events

> Maintainer: BadGuy, joko // Jonas

The Loadout Module simplifies the creation of unit loadouts.

This approach uses config class definitions as loadout definitions. Due to this technique, class inheritance is possible and simplifies the mission editors life.

## Create Loadouts

Every user created loadout is described in loadoutFramework/cfgLoadouts.hpp. In this file, only classes inherited from the Collection-class should be inserted.

The Collection-class
The Collection-class is the base class for all classes defined in the framework. This class describes the basic loadout-slots used in the framework.

```csharp
class Collection {
    uniform[] = {}; // Uniform. e.g. {'U_B_CombatUniform_mcam'}
    vest[] = {}; // Vest
    headgear[] = {}; // Headgear like helmets
    goggle[] = {}; // Goggles
    backpack[] = {}; // Backpack
    primaryWeapon[] = {}; //primary Weapon
    primaryWeaponOptic[]={}; // Scope for primary Weapon
    primaryWeaponMuzzle[]={}; // Muzzle Attachment for prim. Weapon
    primaryWeaponBarrel[] = {}; // Barrel Attachment for prim Weapon
    primaryWeaponResting[] = {}; // Weapon Resting Attachment like bi-pods
    primaryWeaponLoadedMagazine[] = {}; // the loaded magazine
    secondaryWeapon[] = {}; // secondary Weapon
    secondaryWeaponOptic[]={}; // same like primaryWeaponOptic see above
    secondaryWeaponMuzzle[]={};
    secondaryWeaponBarrel[] = {};
    secondaryWeaponResting[] = {};
    secondaryWeaponLoadedMagazine[] = {};
    handgun[] = {}; // handgun
    handgunOptic[]={}; // same like primaryWeaponOptic see above
    handgunMuzzle[]={};
    handgunBarrel[] = {};
    handgunLoadedMagazine[] = {};
    binocular[] = {};
    magazines[] = {}; // all magazines which can be stored in uniform, vest or backpack depending on space. E.g. {{"30Rnd_65x39_caseless_mag_Tracer",3},{"30Rnd_65x39_caseless_mag",6}}; for 3x 30 Rnd 6.5x39mm caseless Tracer and 6x 30 Rnd 6.5x39mm caseless magazines
    items[] = {}; // all other items (magazines are also possible) which can be stored in uniform, vest or backpack depending on space. Same definition like magazines[].
    itemsUniform[] = {}; // all items (magazines are also possible) which have to be stored in uniform. Same definition like magazines[].
    itemsVest[]={}; // all items (magazines are also possible) which have to be stored in vest. Same definition like magazines[].
    itemsBackpack[] = {}; // all items (magazines are also possible) which have to be stored in backpack. Same definition like magazines[].
    linkedItems[] = {};// all items which are linked to a special slot (NVG, Map, Watch etc.). E.g. {"ItemWatch","ItemCompass","ItemMap","NVGoggles"};
    script[] = {};// A script which is executed after applying loadout.
};
```

Every property is defined as an array. This allows the user to define multiple e.g. uniforms. The system chooses then one uniform randomly.

Custom Loadout
By inheriting the Collection-class (class MyLoadout : Collection), you can define your custom loadout by filling the properties. As class inheritance is possible, you can define additional loadouts based on other loadouts.

Additional, you are able to aggregate sub-collections. Maybe you want to have a medical backpack and some weapons with a predefined magazine loadout, you can create some sub-collections which can be added to your unit-loadout.

```csharp
class Weapon_MX : Collection { // ideally added to cfgTemplates.hpp but not necessary
    primaryWeapon[] = {"arifle_MX_F"};
    primaryWeaponOptic[]={"optic_Aco"};
    primaryWeaponLoadedMagazine[]={"30Rnd_65x39_caseless_mag"};
    primaryWeaponBarrel[] = {"acc_pointer_IR"};
    magazines[] = {{"30Rnd_65x39_caseless_mag_Tracer",3},{"30Rnd_65x39_caseless_mag",6}};
};

class AnotherClass : Collection {
...
};

class Rifleman : Collection {
    uniform[] = {"U_B_CombatUniform_mcam"};
    vest[] = {"V_PlateCarrierL_CTRG"};
    headgear[] = {"H_HelmetB_camo"};
    goggle[] = {"G_Combat"};
    backpack[] = {"B_AssaultPack_mcamo"};
    handgun[] = {"hgun_P07_F"};
    magazines[] = {{"16Rnd_9x21_Mag",2}};
    itemsBackpack[] = {{"FirstAidKit",3}};
    linkedItems[]={"ItemWatch","ItemCompass","ItemMap","NVGoggles"};
    class PrimaryWeaponClass : Weapon_MX { // Some Collections added to Rifleman Collection
        primaryWeaponOptic[]={}; // Change optic to iron sight for this collection
    };
    class AnotherSubCollaction : AnotherClass {};
};
```

As shown in this example, you can simply overwrite certain properties (primary weapon was changed to iron sight), if you wish to change the loadout for some loadouts.

Sub-collections which are not usable standalone, should be created in the cfgTemplates.hpp-file.

### Applying the Loadout

The function CLib_fnc_applyLoadout applies the loadout to a unit.

## Data Types

### SearchData

* [`<String>`] Search Key
* [`<Anything>`] Default Value

## Functions

### CLib_fnc_applyLoadout

Parameter(s):
* [`<Object>`] Unit that get the Loadout
* [`<String>`], [`<Config>`] Loadout Class
* [`<Boolean>`] Allow Random Items

Returns:
* None

Applys a loadout to a unit

Examples:

```sqf
[player, "Rifleman_Opfor", true] call CLib_fnc_applyLoadout;
```

### CLib_fnc_getAllLoadouts

Parameter(s):
* None

Returns:
* [`<Array>`] of [`<String>`] with all Names of Loadouts

Returns all available loadouts

Examples:

```sqf
private _allLoadouts = call CLib_fnc_getAllLoadouts;
```

### CLib_fnc_getLoadoutDetails

Parameter(s):
* [`<String>`], [`<Config>`] Loadout Class
* [`<Array>`] of [`<SearchData>`] Search Requests

Returns:
* [`<Array>`] of [`<Anything>`] form Serached Data or Default Value

Returns loadout details

Examples:

```sqf
[
    "Rifleman_Opfor",
    [
        ["removeAllWeapons", 0],
        ["linkedItems", [["myLinkedItems"]]]
    ]
] call CLib_fnc_getLoadoutDetails;
```

### CLib_fnc_loadLoadout

Parameter(s):
* [`<String>`], [`<Config>`] Loadout Class

Returns:
* [`<Array>`] Loadout Data

Load loadout to Unit

Examples:

```sqf
private _loadouts = "Rifleman_Opfor" call CLib_fnc_loadLoadout;
```

[`<SearchData>`]: #SearchData
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
