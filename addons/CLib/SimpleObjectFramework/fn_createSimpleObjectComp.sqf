#include "macros.hpp"
/*
    Community Lib - CLib

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
params ["_input", "_pos", "_dir", ["_ignoreObj1", objNull], ["_ignoreObj2", objNull]];

_input = switch (typeName _input) do {
    case "STRING": {
        GVAR(namespace) getVariable _input
    };
    case "CONFIG": {
        if (!isServer) then {
            LOG("Error: you Try to Load a Config form a Client that is Not the Server");
        };
        if (isNil "_input" || {_input isEqualTo []}) then {
            _input call CFUNC(readSimpleObjectComp)
        } else {
            GVAR(namespace) getVariable (configName _input)
        }
    };
};

_input params ["_alignOnSurface", "_objects"];

if (isNil "_input" || {_input isEqualTo []}) exitWith {
    LOG("ERROR SimpleObjectComp Dont exist: " + _input);
    []
};
private _intersections = lineIntersectsSurfaces [
    AGLToASL _pos,
    AGLToASL _pos vectorAdd [0, 0, -100],
    _ignoreObj1,
    _ignoreObj2
];

private _normalVector = (_intersections select 0) select 1;
private _posVectorASL = (_intersections select 0) select 0;

private _originObj = "Land_HelipadEmpty_F" createVehicleLocal ASLToAGL _posVectorASL;
_originObj setPosASL _posVectorASL;

private _xVector = _dir vectorCrossProduct _normalVector;
_dir = _normalVector vectorCrossProduct _xVector;
private _ovUp = [[0, 0, 1], _normalVector] select _alignOnSurface;

_originObj setVectorDirAndUp [_dir, _ovUp];

private _originPosAGL = _originObj modelToWorld [0, 0, 0];
private _originPosASL = AGLToASL _originPosAGL;

private _return = [];
{
    _x params ["_path", "_posOffset", "_dirOffset", "_upOffset", "_hideSelectionArray", "_animateArray", "_setObjectTextureArray"];

    private _obj = objNull;

    _obj = createSimpleObject [_path, AGLToASL (_originObj modelToWorld _posOffset)];
    _obj setVariable [QGVAR(isSimpleObject), true, true];
    _obj setVectorDirAndUp [AGLToASL (_originObj modelToWorld _dirOffset) vectorDiff _originPosASL, AGLToASL (_originObj modelToWorld _upOffset) vectorDiff _originPosASL];

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

    if (_setObjectTextureArray isEqualType [] && {!(_setObjectTextureArray isEqualTo [])}) then {
        {
            _x params ["_type", "_id", "_path"];
            if (_type isEqualTo 1) then {
                _obj setObjectMaterialGlobal [_id, _path];
            } else {
                _obj setObjectTextureGlobal [_id, _path];
            };
            nil
        } count _setObjectTextureArray;
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
