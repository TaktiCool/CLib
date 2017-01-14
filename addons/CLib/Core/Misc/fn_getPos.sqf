#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Wrapper for getPos if you are not sure wether you get an object array or string

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
