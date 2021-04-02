#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add item Wraper

    Parameter(s):
    0: Unit <Object> (Default: objNull)
    1: Item data <String, Array> (Default: ["", 0])
    2: Add Item to Container <Number> (Default: -1)

    Returns:
    None

    Remarks:
    Item data:
        0: Item Classname <String> (Default: "")
        1: Item count <Number> (Default: 1)

    Container Number:
        -1: Any
        0: Uniform
        1: Vest
        2: Backpack
*/

params [
    ["_unit", objNull, [objNull]],
    ["_itemData", ["", 0], ["", []]],
    ["_container", -1]
];

if (_itemData isEqualType "") then {
    _itemData = [_itemData, 1];
};

_itemData params [
    ["_className", ""],
    ["_count", 1]
];
if (_container isEqualType "") then {
    switch (toLower (_container)) do {
        case ("uniform"): {
            _container = 0;
        };
        case ("vest"): {
            _container = 1;
        };
        case ("backpack"): {
            _container = 2;
        };
        default {
            _container = -1;
        };
    };
};
if (_className != "" && _count > 0) then {
    for "_i" from 1 to _count do {
        switch (_container) do {
            case (0): {
                if (_unit canAddItemToUniform _className) then {
                    _unit addItemToUniform _className;
                } else {
                    private _message = format ["Item %1 can't added because Gear is Full", _className];
                    LOG(_message);
                    #ifdef ISDEV
                    hintSilent _message;
                    #endif
                };
            };
            case (1): {
                if (_unit canAddItemToVest _className) then {
                    _unit addItemToVest _className;
                } else {
                    private _message = format ["Item %1 can't added because Gear is Full", _className];
                    LOG(_message);
                    #ifdef ISDEV
                    hintSilent _message;
                    #endif
                };
            };
            case (2): {
                if (_unit canAddItemToBackpack _className) then {
                    _unit addItemToBackpack _className;
                } else {
                    private _message = format ["Item %1 can't added because Gear is Full", _className];
                    LOG(_message);
                    #ifdef ISDEV
                    hintSilent _message;
                    #endif
                };
            };
            default {
                if (_unit canAdd _className) then {
                    _unit addItem _className;
                } else {
                    private _message = format ["Item %1 can't added because Gear is Full", _className];
                    LOG(_message);
                    #ifdef ISDEV
                    hintSilent _message;
                    #endif
                };
            };
        };

    };
};
