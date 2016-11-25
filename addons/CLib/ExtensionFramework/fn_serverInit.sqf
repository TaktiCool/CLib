#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init Some Events for Extension Framework

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(tasks) = call CFUNC(createNamespace);

[QGVAR(extensionRequest), {
    (_this select 0) params ["_extensionName", "_actionName", "_data", "_sender", "_senderId"];

    if (!(_data isEqualType "")) then {
        _data = str _data;
    };

    private _parameterString = format [">%1|%2", _extensionName, _actionName];
    if (_data != "") then {
        _parameterString = format ["%1|%2", _parameterString, _data select [0, 7000 - (count _parameterString)]];
        _data = _data select [7000 - (count _parameterString), count _data];
    };
    private _taskId = "CLib" callExtension _parameterString;

//    private _position = 0;
//    while {_position <= count _data} do {
//        "CLib" callExtension (_data select [_position, 7000]);
//        _position = _position + 7000;
//    };

    GVAR(tasks) setVariable [_taskId, [_sender, _senderId]];
}] call CFUNC(addEventHandler);

[{
    private _result = "CLib" callExtension "<";
    private _taskIds = _result splitString "|";
}] call CFUNC(addPerFrameHandler);