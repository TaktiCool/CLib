#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add item Wraper

    Parameter(s):
    0: Unit <Object> (Default: objNull)
    1: Item data <Array or String> (Default: ["", 0])

    Returns:
    None

    Remarks:
    Item data:
        0: Item Classname <String> (Default: "")
        1: Item count <Number> (Default: 1)
*/

params [
    ["_unit", objNull],
    ["_itemData", ["", 0], ["",[]]]
];

if (_itemData isEqualType "") then {
    _itemData = [_itemData, 1];
};

_itemData params [
    ["_className", ""],
    ["_count", 1]
];

if (_className != "" && _count > 0) then {
    for "_i" from 1 to _count do {
        if (_unit canAdd _className) then {
            _unit addItem _className;
        } else {
            private _message = format ["Item %1 can't added because Gear is Full", _className];
            LOG(_message);
        };
    };
};
