# lnbData

> Maintainer: joko // Jonas

lnbData is a Module that adds the Possibility to save all Type of Data on an lnb Control


## CLib_fnc_lnbSave

Parameter(s):
* [`<Control>`] Control
* [`<Array>`] Row and Column as [`<Number>`]
* [`<Anything>`] Data that get Saved on the Control

Returns:
* None

Save a Value on a lnb.

Examples:
```sqf
[_control, [1,4], "nice Bananas"] call CLib_fnc_lnbSave;
```

## CLib_fnc_lnbLoad

Parameter(s):
* [`<Control>`] Control
* [`<Array>`] Row and Column as [`<Number>`]

Returns:
* [`<Anything>`] Data that is Saved on the Control

Read a Value from a lnb.

Examples:
```sqf
private _data = [_control, [1,4]] call CLib_fnc_lnbLoad;
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
