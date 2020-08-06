#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: Glowbal
    https://github.com/acemod/ACE3/blob/845dca9ea529888e3cfddb36e809a88396f6aa07/addons/common/functions/fnc_blurScreen.sqf

    Description:
    Blur the Screen

    Parameter(s):
    0: ID <Number, String> (Default: 0)
    1: Blur <Bool, Number> (Default: false)
    2: Commit time <Number> (Default: 0.5)

    Returns:
    None
*/

if (!hasInterface) exitWith {};

params [
    ["_id", 0, [0, ""]],
    ["_show", false, [true, 0]],
    ["_commitTime", 0.5, [0]]
];

if (_show isEqualType 0) then {
    _show = _show == 1;
};

if (isNil QGVAR(SHOW_BLUR_SCREEN_COLLECTION)) then {
    GVAR(SHOW_BLUR_SCREEN_COLLECTION) = [];
};

if (_show) then {
    GVAR(SHOW_BLUR_SCREEN_COLLECTION) pushBack _id;

    // show blur
    if (isNil QGVAR(MENU_ppHandle_GUI_BLUR_SCREEN)) then {
        GVAR(MENU_ppHandle_GUI_BLUR_SCREEN) = ppEffectCreate ["DynamicBlur", 102];
        GVAR(MENU_ppHandle_GUI_BLUR_SCREEN) ppEffectAdjust [0.9];
        GVAR(MENU_ppHandle_GUI_BLUR_SCREEN) ppEffectEnable true;
        GVAR(MENU_ppHandle_GUI_BLUR_SCREEN) ppEffectCommit _commitTime;
    };
} else {
    [GVAR(SHOW_BLUR_SCREEN_COLLECTION), _id] call CFUNC(deleteAtEntry);

    if (GVAR(SHOW_BLUR_SCREEN_COLLECTION) isEqualTo []) then {
        // hide blur
        if (!isNil QGVAR(MENU_ppHandle_GUI_BLUR_SCREEN)) then {
            ppEffectDestroy GVAR(MENU_ppHandle_GUI_BLUR_SCREEN);
            GVAR(MENU_ppHandle_GUI_BLUR_SCREEN) = nil;
        };
    };
};
