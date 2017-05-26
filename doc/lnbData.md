# lnbData

> Maintainer: joko // Jonas

lnbData is a Module that add the Posiblity to save all Type of Data on a lnb Control

## CLib_fnc_lnbSave

Parameter(s):
* [`<Control>`] Control
* [`<Array>`] Row and Column as [`<Number>`]
* [`<Any>`] Data that get Saved on the Control

Returns:
* None

Do a Animation for a Unit

Examples:
```sqf
[_control, [1,4], "nice Bananas"] call CLib_fnc_lnbSave;
```

## CLib_fnc_lnbLoad

Parameter(s):
* [`<Control>`] Control
* [`<Array>`] Row and Column as [`<Number>`]

Returns:
* [`<Any>`] Data that is Saved on the Control

Examples:
```sqf
private _data = [_control, [1,4]] call CLib_fnc_lnbLoad;
```

[`<Array>`]: https://community.bistudio.com/wiki/Array
[`<Number>`]: https://community.bistudio.com/wiki/Number
[`<Control>`]: https://community.bistudio.com/wiki/Control
[`<Any>`]: https://community.bistudio.com/wiki/Data_Types
