#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy, NetFusion

    Description:
    Decompression of a String

    Parameter(s):
    0: Compressed string <String> (Default: "")

    Returns:
    Uncompressed string <String>
*/

params [
    ["_input", "", [""]]
];

private _rawInput = toArray _input;
private _rawOutput = [];

#define WINDOWSIZE 2048
#define MINMATCHLENGTH 2

private _inputLength = count _rawInput;
private _outputPosition = MINMATCHLENGTH;

_rawOutput append (_rawInput select [0, MINMATCHLENGTH]);
private _inputPosition = MINMATCHLENGTH;

{
    private _encodeFlag = ((_rawInput select _inputPosition) - 1) / 2;
    _inputPosition = _inputPosition + 1;

    for "_i" from 0 to 6 do {
        if (_encodeFlag % 2 == 1) then {
            private _byteValue = ((floor ((_rawInput select _inputPosition) / 2)) * 256) + (_rawInput select (_inputPosition + 1));
            _inputPosition = _inputPosition + 2;

            private _length = (_byteValue % 16) + MINMATCHLENGTH;
            private _offset = floor (_byteValue / 16);

            if (_offset < _length) then {
                _rawOutput append (_rawOutput select [_outputPosition - _offset + 1, _offset]);
                private _searchSteps = (WINDOWSIZE - 1) min _outputPosition;
                for "_j" from _offset to _length step _searchSteps do {
                    _rawOutput append (_rawOutput select [_outputPosition - _searchSteps, _searchSteps min (_length - _j)]);
                };
            } else {
                _rawOutput append (_rawOutput select [_outputPosition - _offset + 1, _length]);
            };

            _outputPosition = _outputPosition + _length;
        } else {
            _outputPosition = _rawOutput pushBack (_rawInput select _inputPosition);
            _inputPosition = _inputPosition + 1;
        };
        _encodeFlag = floor (_encodeFlag / 2);
        if (_inputPosition == _inputLength) exitWith {};
    };

    if (_inputPosition == _inputLength) exitWith {};
    nil
} count _rawInput;

toString _rawOutput
