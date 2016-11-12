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
private _intersections = lineIntersectsSurfaces [
	AGLtoASL _pos,
	AGLtoASL _pos vectorAdd [0,0,-100],
    _ignoreObj1,
    _ignoreObj2
];

private _normalVector = (_intersections select 0) select 1;
private _posVectorASL = (_intersections select 0) select 0;

private _originObj = "Land_HelipadEmpty_F" createVehicleLocal ASLtoAGL _posVectorASL;
_originObj setPosASL _posVectorASL;

private _xVector = _dir vectorCrossProduct _normalVector;
_dir = _normalVector vectorCrossProduct _xVector;
private _ovUp = [[0,0,1], _normalVector] select _alignOnSurface;

_originObj setVectorDirAndUp [_dir, _ovUp];

private _originPosAGL = _originObj modelToWorld [0,0,0];
private _originPosASL = AGLToASL _originPosAGL;

private _return = [];
{
    _x params ["_path", "_posOffset", "_dirOffset", "_upOffset", "_hideSelectionArray", "_animateArray"];

    private _obj = objNull;
    private _isClass = isClass (configFile >> "CfgVehicles" >> _path);

    if (_isClass) then {
        _obj = _path createVehicle (_originObj modelToWorld _posOffset);
        _obj setPosASL AGLtoASL (_originObj modelToWorld _posOffset);
    } else {

        _obj = createSimpleObject [_path, AGLtoASL (_originObj modelToWorld _posOffset)];
    };

    _obj setVectorDirAndUp [AGLtoASL (_originObj modelToWorld _dirOffset) vectorDiff _originPosASL,  AGLtoASL (_originObj modelToWorld _upOffset) vectorDiff _originPosASL];

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
    if (_isClass) then {
        ["enableSimulation", [_obj, false]] call CFUNC(serverEvent);
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
