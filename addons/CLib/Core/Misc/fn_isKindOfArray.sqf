#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Wrapper for isKindOf of multiple types

    Parameter(s):
    0: Object or type <Object, String> (Default: objNull)
    1: Types to check <Array> (Default: [])
    2: Config <Config> (Default: configNull)

    Returns:
    Found <Bool>

    Remarks:
    https://community.bistudio.com/wiki/isKindOf
*/

params [
    ["_inputObjOrType", objNull, [objNull, ""]],
    ["_typesToCheck", [], [[]], []],
    ["_config", configNull, [configNull]]
];

if (isNull _config) then {
    (_typesToCheck findIf {_inputObjOrType isKindOf _x}) != -1;
} else {
    (_typesToCheck findIf {_inputObjOrType isKindOf [_x, _config]}) != -1;
};
