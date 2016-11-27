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
GVAR(groupSeperator) = toString [29];
GVAR(recordSeperator) = toString [30];

[QGVAR(extensionRequest), {
    (_this select 0) params ["_extensionName", "_actionName", "_data", "_sender", "_senderId"];

    if (!(_data isEqualType "")) then {
        _data = str _data;
    };
    _data = _data + GVAR(groupSeperator);

    private _parameterString = format [">%1%2%3", _extensionName, GVAR(recordSeperator), _actionName];
    private _dataPosition = 0;
    if (_data != "") then {
        _parameterString = format ["%1%2%3", _parameterString, GVAR(recordSeperator), _data select [0, 7000 - (count _parameterString)]];
        _dataPosition = 7000 - (count _parameterString);
    };
    private _taskId = "CLib" callExtension _parameterString;

    while {_dataPosition <= count _data} do {
        "CLib" callExtension (">" + (_data select [_dataPosition, 7000]));
        _dataPosition = _dataPosition + 7000;
    };

    GVAR(tasks) setVariable [_taskId, [_sender, _senderId]];
}] call CFUNC(addEventHandler);

[{
    private _result = "CLib" callExtension "<";
    if (_result == "") exitWith {};

    private _results = _result splitString GVAR(groupSeperator);
    {
        (_x splitString GVAR(recordSeperator)) params ["_taskId", "_result"];
        ([GVAR(tasks), _taskId, [objNull, 0]] call CFUNC(getVariable)) params ["_sender", "_senderId"];

        [QGVAR(extensionResult), _sender, [_senderId, _result]] call CFUNC(targetEvent);
        nil
    } count _results;
}] call CFUNC(addPerFrameHandler);