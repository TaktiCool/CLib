#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Returns loadout details

    Parameter(s):
    0: Classname or config of loadout <Config, String> (Default: "")
    1: Requested details <Array> (Default: [])

    Returns:
    Array With all Informations <Array>

    Remarks:
    Requested details array values
        0: Requested data name <String>
        1: Default if data not exist <Anything>
*/

params [
    ["_name", "", [configNull, ""]],
    ["_request", [], [[]], []]
];

private _loadout = _name call CFUNC(loadLoadout);
_request apply {
    _x params [
        ["_findData", "", [""]],
        ["_ret", "", []]
    ];

    {
        _ret = [_x, toLower _findData, _ret] call CFUNC(getHash);
    } forEach _loadout;
    _ret;
};
