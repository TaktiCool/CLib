#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Returns loadout details

    Parameter(s):
    0: LoadoutName <String, Config>
    1: Requested details <Array>
        0: Requested Detail
            0: Requested Data <String>
            1: Default if Data not exist <any>

    Returns:
    Array With all Informations <Array>
*/
params [["_name", "", ["", configNull]], ["_request", [], [[]]]];

private _loadout = _name call CFUNC(loadLoadout);
_request apply {
    _x params ["_findData", ["_ret", ""]];
    {
        private _index = _x find (toLower (_findData));
        if (_index != -1) exitWith {
            _ret = _x select (_index + 1);
        };
    } forEach _loadout;
    _ret;
};
