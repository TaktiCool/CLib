#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    This function fixes an issue occuring when using str on a config without appending the complete file path

    Parameter(s):
    0: Argument <Type>

    Returns:

*/
params ["_configPath", ["_seperator", "/", [""]]];

private _return = [];

private _hierarchy = configHierarchy (_configPath);

{
    private _name = switch (_x) do {
        case (configFile): {
            "configFile"
        };
        case (missionConfigFile): {
            "missionConfigFile"
        };
        case (campaignConfigFile): {
            "campaignConfigFile"
        };
        default {
            configName _x
        };
    };
    _return pushBack _name;
    nil
} count _hierarchy;

_return joinString _seperator;
