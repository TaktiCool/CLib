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
    DUMP(_data)
    private _parameterString = format [">%1%2%3", _extensionName, toString [30], _actionName];
    DUMP(_parameterString)
    if (_data != "") then {
        _parameterString = format ["%1%2%3", _parameterString, toString [30], _data select [0, 7000 - (count _parameterString)]];
        _data = _data select [7000 - (count _parameterString), count _data];
    };
    private _taskId = "CLib" callExtension _parameterString;
    DUMP(_taskId)
//    private _position = 0;
//    while {_position <= count _data} do {
//        "CLib" callExtension (_data select [_position, 7000]);
//        _position = _position + 7000;
//    };

    GVAR(tasks) setVariable [_taskId, [_sender, _senderId]];
}] call CFUNC(addEventHandler);

[{
    private _result = "CLib" callExtension "<";
    if (_result == "") exitWith {};

    private _results = _result splitString (toString [29]);
    {
        (_x splitString (toString [30])) params ["_taskId", "_result"];
        DUMP(_x)
        DUMP(_taskId)
        DUMP(_result)
        DUMP(allVariables GVAR(tasks))
        ([GVAR(tasks), _taskId, [objNull, 0]] call CFUNC(getVariable)) params ["_sender", "_senderId"];

        [QGVAR(extensionResult), _sender, [_senderId, _result]] call CFUNC(targetEvent);
        nil
    } count _results;
}] call CFUNC(addPerFrameHandler);