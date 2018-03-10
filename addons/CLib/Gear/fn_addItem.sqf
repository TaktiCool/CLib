#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add item Wraper

    Parameter(s):
    0: Item Classname <String>
    1: Count <Number>

    Returns:
    None
*/
params ["_unit", "_itemData"];
_itemData params ["_className", ["_count", 1]];

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
