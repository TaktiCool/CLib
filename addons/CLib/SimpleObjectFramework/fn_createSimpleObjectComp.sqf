#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    Description

    Parameter(s):
    0: ClassName/ConfigPath/SimpleObjectStructure <String, Config, Array>
    1: Position <Array>
    2: Rotation <Array>

    Returns:
    All SimpleObjects <Array<Objects>>
*/
params ["_input", "_pos", "_dir"];

switch (typeName _input) do {
    case ("STRING"): {
        _input = GVAR(namespace) getVariable _input;
    };
    case ("CONFIG"): {
        if !(isServer) then {
            LOG("Error: you Try to Load a Config form a Client that is Not the Server");
        };
        private _inputNew = GVAR(namespace) getVariable (configName _input);
        if (isNil "_input" || {_input isEqualTo []}) then {
            _input = _input call CFUNC(readSimpleObjectComp);
        } else {
            _input = _inputNew;
        };
    };
};

_input params ["_alignOnSurface", "_objects"];

if (isNil "_input" || {_input isEqualTo []}) exitWith {
    LOG("ERROR SimpleObjectComp Dont exist: " + _input)
    []
};

private _originObj = "#particlesource" createVehicleLocal _pos;
private _ovUp = [[0,0,1], surfaceNormal _pos] select _alignOnSurface;

_originObj setDir _dir;
_originObj setVectorUp _ovUp;


private _return = [];
{
    _x params ["_path", "_posOffset", "_dirOffset", "_upOffset", "_hideSelectionArray", "_animateArray"];



    private _obj = createSimpleObject [_path, _originObj modelToWorldVisual _posOffset];
    // TODO Rotation
    _obj setDir (_dirOffset+_dir);
    _obj setVectorUp (_upOffset vectorAdd _ovUp);

    if (_hideSelectionArray isEqualType [] && {!(_hideSelectionArray isEqualTo [])}) then {
        {
            _obj hideSelection _x;
            nil
        } count _hideSelectionArray;
    };
    if (_animateArray isEqualType [] && {!(_animateArray isEqualTo [])}) then {
        {
            _obj animate _x;
            nil
        } count _animateArray;
    };
    _return pushBack _obj;
    nil
} count _objects;

deleteVehicle _originObj;

_return;
/* return
[
    [
        "PATH",
        [offset],
        [rotation],
        [ // this array can be replace with a Simple FALSE what mean that this gets ignored
            ["hideSelectionName1", true],
            ["hideSelectionName2", fase]
        ],
        [ // this array can be replace with a Simple FALSE what mean that this gets ignored
            [
                ["AnimName", phase, speed]
            ]
        ]
    ]
]
*/
