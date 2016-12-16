#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy, NetFusion

    Description:
    String Compression

    Parameter(s):
    0: input string <String>

    Returns:
    0: compressed String <String>
*/

params ["_input", ["_compression", "LZSS"]];

private _type = ["LZSS", "LZW"] find _compression;

private _rawInput = toArray _input;
private _output = "";
private _rawOutput = [_type + 1];

switch (_compression) do {
    case ("LZW"): { // TODO there is a string which produces a bug
        if (isNil QGVAR(lzwDictonary)) then {
            GVAR(lzwDictonary) = [];
            for "_i" from 0 to 255 do {
                GVAR(lzwDictonary) pushBack [_i];
            };
        } else {
            GVAR(lzwDictonary) resize 256;
        };

        private _lastSequence = [];
        private _lastSequenceIndex = -1;
        {
            {
                private _byte = [_x];
                private _currentSequence = _lastSequence + _byte;

                private _index = -1;
                {
                    if (_x isEqualTo _currentSequence) exitWith { _index = _forEachIndex };
                } forEach GVAR(lzwDictonary); // TODO check length of squence and only search through part of dict

                if (_index >= 0) then {
                    _lastSequence = _currentSequence;
                    _lastSequenceIndex = _index;
                } else {
                    _rawOutput pushBack _lastSequenceIndex;
                    GVAR(lzwDictonary) pushBack _currentSequence;
                    _lastSequence = _byte;
                    _lastSequenceIndex = _byte select 0;
                };
                nil
            } count (_x call CFUNC(ordToBytes));
            nil
        } count _rawInput;

        if (!(_lastSequence isEqualTo [])) then {
            _rawOutput pushBack _lastSequenceIndex;
        };

        _output = toString _rawOutput;
    };
    case "LZSS": {
        if (true) exitWith {
            _output = [-1, "CLibCompression", "_Compress@4", _input] call EFUNC(ExtensionFramework,extensionRequest);
        };

        // 18/5 would be optimal but may take a lot more time, 11/4 is faster but not that efficient
        #define WINDOWSIZE 2048
        #define MINMATCHLENGTH 2
        #define MAXMATCHLENGTH 17

        private _inputLength = count _rawInput;
        private _writeCache = [];
        private _symbolsWritten = 0;
        private _encodeFlag = 1; // xxxxxxx1

        private _inputPosition = MINMATCHLENGTH;
        private _bestMatchLength = 0;
        private _bestMatchOffset = 0;

        _rawOutput append (_rawInput select [0, MINMATCHLENGTH]);

        {
            private _char = _rawInput select _inputPosition;

            private _windowPosition = 1;
            private _searchSteps = WINDOWSIZE min _inputPosition;
            private _currentMatchLength = 0;
            private _bestMatchLength = 0;
            private _bestMatchOffset = 0;

            while {_windowPosition <= _searchSteps} do { // TODO kmp optimization
                if (_char == (_rawInput select (_inputPosition - _windowPosition))) then {
                    _currentMatchLength = 1;
                    while {(_rawInput select (_inputPosition - _searchSteps + ((_searchSteps - _windowPosition + _currentMatchLength) % _searchSteps))) == (_rawInput select (_inputPosition + _currentMatchLength)) && _currentMatchLength < MAXMATCHLENGTH} do {
                        _currentMatchLength = _currentMatchLength + 1;
                    };

                    if (_currentMatchLength > _bestMatchLength) then {
                        _bestMatchLength = _currentMatchLength;
                        _bestMatchOffset = _windowPosition;
                    };
                };

                _windowPosition = _windowPosition + 1;
            };

            _symbolsWritten = _symbolsWritten + 1;

            if (_bestMatchLength > MINMATCHLENGTH) then {
                _inputPosition = _inputPosition + _bestMatchLength;
                _encodeFlag = _encodeFlag + (2 ^ _symbolsWritten);
                _writeCache append [((floor (_bestMatchOffset / 16)) * 2) + 1, ((_bestMatchOffset % 16) * 16) + (_bestMatchLength - MINMATCHLENGTH)];
            } else {
                _inputPosition = _inputPosition + 1;
                _writeCache pushBack _char;
            };

            if (_symbolsWritten == 7) then {
                _rawOutput pushBack _encodeFlag;
                _rawOutput append _writeCache;
                _encodeFlag = 1;
                _symbolsWritten = 0;
                _writeCache = [];
            };

            if (_inputPosition == _inputLength) exitWith {};
            nil
        } count _rawInput;

        if (!(_writeCache isEqualTo [])) then {
            _rawOutput pushBack _encodeFlag;
            _rawOutput append _writeCache;
        };

        _output = toString _rawOutput;
    };
    default { // No compression
        LOG("String not compressed!")
        _output = _input;
    };
};

_output