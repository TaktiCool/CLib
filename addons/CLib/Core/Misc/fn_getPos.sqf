#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    getPos Wrapper if you dont are sure if you get a object Array or string

    Parameter(s):
    0: Position Data <String, Object, Array>

    Returns:
    Position <Array>
*/

switch (typeName _this) do {
    case ("ARRAY"): {
        _this
    };
    case ("LOCATION");
    case ("GROUP");
    case ("OBJECT"): {
        getPos _this;
    };
    case ("STRING"): {
        getMarkerPos _this;
    };
    case ("TASK"): {
        taskDestination _this;
    };
    default {
        LOG("unkown Type in GetPos with: " + (typeName _this))
        [0,0,0]
    };
};
