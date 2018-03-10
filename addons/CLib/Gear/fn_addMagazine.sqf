#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add magazine Wraper

    Parameter(s):
    0: Magazine Classname <String>
    1: Magazine count <Number>

    Returns:
    None
*/
params ["_unit", "_magazineData"];
_magazineData params ["_className", ["_count", 1]];

private _bullets = -1;
if (_className isEqualType []) then {
    _bullets = _className select 1;
    _className = _className select 0;
};
if (_className != "" && _count > 0) then {
    for "_i" from 1 to _count do {
        if (_unit canAdd _className) then {
            if (_bullets == -1) then {
                _unit addMagazine _className;
            } else {
                _unit addMagazine [_className, _bullets];
            }
        } else {
            private _message = format ["Magazine %1 can't added because Gear is Full", _className];
            LOG(_message);
        };
    };
};
