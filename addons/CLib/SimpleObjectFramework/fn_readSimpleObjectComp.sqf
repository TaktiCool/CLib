#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Read a Simple object out of the config and make a Avable over the SOF

    Parameter(s):
    0: Config Path <Config> (Default: configNull)
    1: Name <String> (Default: config name of the config)

    Returns:
    SimpleObjectStructure <Array>

    Remarks:
    this function only work properly on the Server on Mod Config
*/

params [
    ["_config", configNull, [configNull]],
    ["_name", "", [""]]
];

if (_name isEqualTo "") then {
    _name = configName _config;
};

private _fnc_readSimpleObjectClass = {
    params ["_config"];

    private _path = getText (_config >> "path");
    private _fullObject = getNumber (_config >> "fullObject");
    private _offset = getArray (_config >> "offset");
    private _dir = getArray (_config >> "dirVector");
    private _up = getArray (_config >> "upVector");

    if (_up isEqualTo []) then {
        _up = [0, 0, 0];
    };
    if (_dir isEqualTo []) then {
        _dir = [0, 0, 0];
    };
    if (_offset isEqualTo []) then {
        _offset = [0, 0, 0];
    };

    private _animateArray = [];
    // Animation States
    if (isClass (_config >> "animate")) then {
        {
            private _phase = getNumber (_x >> "phase");
            private _speed = switch (getText (_x >> "speedType")) do {
                case ("BOOL"): {
                    (getNumber (_x >> "speed")) isEqualTo 1
                };
                default {
                    if (isNumber (_x >> "speed") || isText (_x >> "speed")) then {getNumber (_x >> "speed")};
                };
            };
            if (isNil "_speed") then {
                _animateArray pushBack [configName _x, _phase];
            } else {
                _animateArray pushBack [configName _x, _phase, _speed];
            };

            nil
        } count (configProperties [_config >> "animate", "isClass _x", true]);
    };
    if (_animateArray isEqualTo []) then {
        _animateArray = false;
    };

    private _hideSelectionArray = [];
    if (isClass (_config >> "hideSelection")) then {
        {
            _hideSelectionArray pushBack [configName _x, getNumber _x];
            nil
        } count (configProperties [_config >> "hideSelection", "true", true]);
    };
    if (_hideSelectionArray isEqualTo []) then {
        _hideSelectionArray = false;
    };

    private _setObjectTextureArray = [];
    if (isClass (_config >> "setTexture")) then {
        {
            _setObjectTextureArray pushBack [getNumber (_x >> "isMaterial"), getNumber (_x >> "id"), getText (_x >> "texture")];
            nil
        } count (configProperties [_config >> "setTexture", "true", true]);
    };
    if (_setObjectTextureArray isEqualTo []) then {
        _setObjectTextureArray = false;
    };

    [_path, _offset, _dir, _up, _hideSelectionArray, _animateArray, _setObjectTextureArray, _fullObject]
};

private _return = [];
private _childs = configProperties [_config, "isClass _x", true];
_childs = _childs select {!((configName _x) in ["animate", "hideSelection", "setTexture"])};
private _alignOnSurface = getNumber (_config >> "alignOnSurface");

if (_childs isEqualTo []) then {
    _return pushBack (_config call _fnc_readSimpleObjectClass);
} else {
    {
        _return pushBack (_x call _fnc_readSimpleObjectClass);
        nil
    } count _childs;
};
_return = [_alignOnSurface, _return];

GVAR(namespace) setVariable [_name, _return, true];
_return;

/* return
[
    [
        "PATH",
        [offset],
        [dir],
        [up],
        [ // this array can be replace with a Simple FALSE what mean that this gets ignored
            ["hideSelectionName1", true],
            ["hideSelectionName2", fase]
        ],
        [ // this array can be replace with a Simple FALSE what mean that this gets ignored
            [
                ["AnimName", phase, speed]
            ]
        ],
        [ // this array can be replace with a Simple FALSE what mean that this gets ignored
            [id, Texture]
        ]
    ]
]
*/
