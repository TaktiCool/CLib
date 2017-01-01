#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    converts a Array of String to a Config Path

    Parameter(s):
    Array<String> ConfigPath Array

    Returns:
    Config Path
*/
private _path = switch (_this select 0) do {
    case "missionConfigFile": {missionConfigFile};
        case "configFile": {configFile};
        case "campaignConfigFile": {campaignConfigFile};
};
{
    _path = (_path >> _x);
    nil
} count _this;
_path