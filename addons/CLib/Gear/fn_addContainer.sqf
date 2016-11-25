#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add Container Wrapper

    Parameter(s):
    0: Unit <Object>
    1: Container Classname <String>
    2: Type Of Classname <Number>(Default: generated out of Config)

    Returns:
    None
*/
params [["_unit", objNull, [objNull]], ["_containerClassName", "", ["STRING"]], ["_containerNumber", -1, [-1]]];

if (_containerNumber == -1) then {
    private _cfg = configFile >> "CfgWeapons";
    if (_containerClassName isKindOf ["Uniform_Base", _cfg]) then {
        _containerNumber = 0;
    };
    if (_containerClassName isKindOf ["Vest_NoCamo_Base", _cfg] || _containerClassname isKindOf ["Vest_Camo_Base", _cfg]) then {
        _containerNumber = 1;
    };
    if (_containerClassName isKindOf "Bag_Base") then {
        _containerNumber = 2;
    };
};

switch (_containerNumber) do {
    case 0: {
        _uniformName = uniform _unit;
        if(_containerClassName == _uniformName && _containerClassName != "") then {
            _uniform = uniformContainer _unit;
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
        _vestName = vest _unit;
        if(_containerClassName == _vestName && _containerClassName != "") then {
            _vest = vestContainer _unit;
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
        _backpackName = backpack _unit;
        if(_containerClassName == _backpackName && _containerClassName != "") then {
            _backpack = backpackContainer _unit;
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
