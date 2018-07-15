#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add Container Wrapper

    Parameter(s):
    0: Unit <Object> (Default: objNull)
    1: Container classname <String> (Default: "")
    2: Type of classname <Number, String> (Default: -1)

    Returns:
    None
*/

params [
    ["_unit", objNull, [objNull]],
    ["_containerClassName", "", [""]],
    ["_containerType", -1, [0, ""]]
];

if (_containerType isEqualType "") then {
    switch (toLower (_containerType)) do {
        case ("uniform"): {
            _containerType = 0;
        };
        case ("vest"): {
            _containerType = 1;
        };
        case ("backpack"): {
            _containerType = 2;
        };
        default {
            _containerType = -1;
        };
    };
};

if (_containerType == -1) then {
    private _cfg = configFile >> "CfgWeapons";
    if (_containerClassName isKindOf ["Uniform_Base", _cfg]) then {
        _containerType = 0;
    };
    if ([_containerClassName, [["Vest_NoCamo_Base", _cfg], ["Vest_Camo_Base", _cfg]]] call CFUNC(isKindOfArray)) then {
        _containerType = 1;
    };
    if (_containerClassName isKindOf "Bag_Base") then {
        _containerType = 2;
    };
};

switch (_containerType) do {
    case 0: {
        private _uniformName = uniform _unit;
        if (_containerClassName == _uniformName && _containerClassName != "") then {
            private _uniform = uniformContainer _unit;
            clearItemCargoGlobal _uniform;
            clearMagazineCargoGlobal _uniform;
            clearWeaponCargoGlobal _uniform;
        } else {
            removeUniform _unit;

            if (_containerClassName != "") then {
                _unit forceAddUniform _containerClassName;
            };
        };
    };
    case 1: {
        private _vestName = vest _unit;
        if (_containerClassName == _vestName && _containerClassName != "") then {
            private _vest = vestContainer _unit;
            clearItemCargoGlobal _vest;
            clearMagazineCargoGlobal _vest;
            clearWeaponCargoGlobal _vest;
        } else {
            removeVest _unit;

            if (_containerClassName != "") then {
                _unit addVest _containerClassName;
            };
        };
    };
    case 2: {
        private _backpackName = backpack _unit;
        if (_containerClassName == _backpackName && _containerClassName != "") then {
            private _backpack = backpackContainer _unit;
            clearItemCargoGlobal _backpack;
            clearMagazineCargoGlobal _backpack;
            clearWeaponCargoGlobal _backpack;
        } else {
            removeBackpack _unit;

            if (_containerClassName != "") then {
                _unit addBackpack _containerClassName;
            };
        };
    };
};
