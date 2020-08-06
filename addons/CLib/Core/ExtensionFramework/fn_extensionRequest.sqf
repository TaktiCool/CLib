#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Communication interface to the extension. Data transmission according to RFC20.
    See https://tools.ietf.org/pdf/rfc20.pdf for details.

    Parameter(s):
    0: Task ID <Number> (Default: -1)
    1: Extension name <String> (Default: nil)
    2: Action name <String> (Default: "")
    3: Data <Anything>

    Returns:
    None or <String>
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_taskId", -1, [0]],
    ["_extensionName", nil, [""]],
    ["_actionName", "", [""]],
    "_data"
];

#define TRANSMISSIONSIZE 7000

// Make sure data is a string
if (!(_data isEqualType "")) then {
    _data = str _data;
};

// Append the end-of-text symbol cause data may be transmitted splitted
_data = _data + GVAR(ETX);
private _dataCount = count _data;

// Build the header (header should not be more than 7000 characters by definition)
private _header = format ["%1%2%3%4%5%6%7", GVAR(SOH), _taskId, GVAR(US), _extensionName, GVAR(US), _actionName, GVAR(STX)];
private _headerLength = count _header;

// Fill the rest with data
private _dataPosition = TRANSMISSIONSIZE - _headerLength;

// Create first chunk of data
while {_data select [_dataPosition - 1, 1] == GVAR(RC)} do {
    _dataPosition = _dataPosition - 1;
};
private _dataChunk = _data select [0, _dataPosition];

private _parameterString = format ["%1%2", _header, _dataChunk];

// Transmit to extension
private _result = "CLib" callExtension _parameterString;

// Tranmit the remaining data in chunks of TRANSMISSIONSIZE
while {_dataPosition <= _dataCount && _result == GVAR(ACK)} do {
    private _chunkSize = TRANSMISSIONSIZE;
    while {_data select [_dataPosition + _chunkSize - 1, 1] == GVAR(RC)} do {
        _chunkSize = _chunkSize - 1;
    };
    _dataChunk = _data select [_dataPosition, _chunkSize];
    _result = "CLib" callExtension _dataChunk;
    _dataPosition = _dataPosition + _chunkSize;
};

// Start the result fetcher if we did not get a result yet
if (_taskId >= 0 && _result == GVAR(ACK)) exitWith {
    GVAR(pendingTasks) = GVAR(pendingTasks) + 1;
    if (GVAR(pendingTasks) == 1) then {
        [{
            params ["_args", "_id"];

            // Ask for data from the extension
            private _result = "CLib" callExtension GVAR(ENQ);
            if ((_result select [0, 1]) != GVAR(SOH)) exitWith {};

            // Fetch and parse all chunks of data
            private _results = _result call FUNC(extensionFetch);

            // Check if we need to listen for more results
            if (GVAR(pendingTasks) == 0) then {
                _id call CFUNC(removePerFrameHandler);
            };
        }] call CFUNC(addPerFrameHandler);
    };
    nil
};

// Parse the result if there is one
if (_taskId == -1 && (_result select [0, 1]) == GVAR(STX)) exitWith {
    // Fetch and parse all chunks of data
    _result call FUNC(extensionFetch)
};

_result
