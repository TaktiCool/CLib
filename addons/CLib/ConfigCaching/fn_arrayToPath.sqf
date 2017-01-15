#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Converts a array of string to a config path

    Parameter(s):
    ConfigPaths <Array>

    Returns:
    Config Path <Config>
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