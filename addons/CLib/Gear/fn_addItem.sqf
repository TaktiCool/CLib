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
params ["_className", ["_count", 1]];

if (_className != "" && _count > 0) then {
    for "_i" from 1 to _count do {
        if (CLib_Player canAdd _className) then {
            CLib_Player addItem _className;
        } else {
            hint format ["Item %1 can't added because Gear is Full", _className];
        };
    };
};