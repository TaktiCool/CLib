#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    is Kind Of Array

    Parameter(s):
    0: Target for isKindOf <Object, String>
    1: Compare Types <Array<String>>
    2: Config to Search in <Config> (Default: configNull)

    Returns:
    Bool is Kind Of Input1
*/
params [
    ["_input", objNull, [objNull, ""]],
    ["_inputs", [], [[]]],
    ["_config", configNull, [configNull]]
];
if (isNull _config) then {
    (_inputs findIf {_input isKindOf _x}) != -1;
} else {
    (_inputs findIf {_input isKindOf [_x, _config]}) != -1;
};
