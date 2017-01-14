#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Returns loadout details
    
    Parameter(s):
    0: LoadoutName <String, Config>
    1: Requested details <Array>
    
    Returns:
    Array With all Informations <Array>
*/
params [["_name", "", ["", configNull]], ["_request", [], [[], ""]]];

private _loadout = _name call call CFUNC(loadLoadout);

_request apply {
    _x params ["_findData", ["_ret", ""]];
    _findData = toLower _findData;
    {
        private _index = _x find _findData;
        if (_index != -1) exitWith {
            _ret = _x;
        };
        nil
    } count _loadout;
};