#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Wrapper for getPos if you are not sure if you get an object array or string

    Parameter(s):
    0: Position Data <String, Object, Array>

    Returns:
    Position <Array>
*/
params [
    ["_entity", objNull, [objNull, grpNull, "", locationNull, taskNull, [], 0]] // [] and 0 to handle position
];

switch (typeName _entity) do {
    case ("ARRAY"): {
        if (_entity isEqualTypeArray [grpNull, 0]) then {
            getWPPos _entity;
        } else {
            + _entity;
        };
    };
    case ("LOCATION");
    case ("OBJECT"): {
        getPos _entity;
    };
    case ("GROUP"): {
        if (_this isEqualType [] && {_this isEqualTypeArray [grpNull, 0]}) then {
            getWPPos _this;
        } else {
            getPos (leader _entity);
        };
    };
    case ("STRING"): {
        getMarkerPos _entity;
    };
    case ("TASK"): {
        taskDestination _entity;
    };
    case ("SCALAR"): {
        + _entity;
    };
    default {
        LOG("unkown Type in GetPos with: " + (typeName _this));
        [0, 0, 0]
    };
};
