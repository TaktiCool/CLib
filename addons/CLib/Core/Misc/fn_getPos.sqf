#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Wrapper for getPos if you are not sure if you get an object array or string

    Parameter(s):
    0: Position Data <String, Object, Group, Location, Task, Array, Number> (Default: objNull)

    Returns:
    Position <Array>
*/

params [
    ["_entity", objNull, ["", objNull, grpNull, locationNull, taskNull, [], 0], [2, 3]]
];

if (_this isEqualType [] && {_this isEqualTypeArray [grpNull, 0]}) then {
    _entity = _this;
};

switch (typeName _entity) do {
    case ("ARRAY"): {
        if (_entity isEqualTypeArray [grpNull, 0]) then {
            getWPPos _entity;
        } else {
            +_entity;
        };
    };
    case ("LOCATION");
    case ("OBJECT"): {
        getPos _entity;
    };
    case ("GROUP"): {
        getPos (leader _entity);
    };
    case ("STRING"): {
        getMarkerPos _entity;
    };
    case ("TASK"): {
        taskDestination _entity;
    };
    case ("SCALAR"): {
        +_this;
    };
    default {
        LOG("unkown Type in GetPos with: " + (typeName _this));
        [0, 0, 0]
    };
};
