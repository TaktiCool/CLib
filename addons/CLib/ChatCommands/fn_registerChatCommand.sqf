#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Registers a Chat Command

    Parameter(s):
    0: Command <String>
    1: Callback <Code>
    2: Arguments <Anything> (default: [])
    3: Available For <Array<String>> (default: ["all"])
    4: Channels <Array<Number>> (default: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16])

    Remarks:
    Available for:
    "all": Every Client
    "admin": Voted or Logged Admin
    "PLAYERUID": a Specific Player UID

    Returns:
    None
*/

params [
    ["_command", "nocommand", [""]],
    ["_callback", {}, [{}]],
    ["_args", [], []],
    ["_availableFor", ["all"], [[]]],
    ["_channels", GVAR(chatChannels), [[]]]
];

GVAR(chatCommands) set [_command, [_callback, _availableFor, _args, _channels]];
