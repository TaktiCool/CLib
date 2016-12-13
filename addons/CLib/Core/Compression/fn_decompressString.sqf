#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy, NetFusion

    Description:
    Decompression of a String

    Parameter(s):
    0: compressed string <String>

    Returns:
    0: uncompressed string <String>
*/

params ["_input"];

private _rawInput = toArray _input;
private _rawOutput = [];

private _type = (_rawInput deleteAt 0) - 1;

switch (_type) do {
    case 0: { //LZ77
        DUMP(_rawInput)
        #define MINMATCHLENGTH 3

        private _inputLength = count _rawInput;
        private _outputLength = 0;
        private _symbolsRead = 0;
        private _encodeFlag = 0;

        private _inputPosition = MINMATCHLENGTH;

        _rawOutput append (_rawInput select [0, MINMATCHLENGTH]);

        {
            private _char = _rawInput select _inputPosition;

            if (_symbolsRead == 0) then {
                _encodeFlag = floor (_char / 2);
            } else {
                if (_encodeFlag % 2 == 1) then {
                    _inputPosition = _inputPosition + 1;
                    private _byteValue = ((floor (_char / 2)) * 256) + (_rawInput select (_inputPosition - 1));
                    private _length = _byteValue % 16;
                    _rawOutput append (_rawOutput select [_outputLength - (floor (_byteValue / 16)), _length + MINMATCHLENGTH]);
                    _outputLength = _outputLength + _length;
                } else {
                    _outputLength = _rawOutput pushBack _char;
                };
                _encodeFlag = floor (_encodeFlag / 2);
            };

            _symbolsRead = _symbolsRead + 1;
            _inputPosition = _inputPosition + 1;

            if (_symbolsRead == 8) then {
                _symbolsRead = 0;
                _encodeFlag = 0;
            };

            if (_inputPosition == _inputLength) exitWith {};
            nil
        } count _rawInput;
    };
    case 1: { // LZW
        if (isNil QGVAR(lzwDictonary)) then {
            GVAR(lzwDictonary) = [];
            for "_i" from 0 to 255 do {
                GVAR(lzwDictonary) pushBack [_i];
            };
        } else {
            GVAR(lzwDictonary) resize 256;
        };

        private _bytes = [];
        private _lastSequence = [];
        {
            private _entry = GVAR(lzwDictonary) select _x;
            if (isNil "_entry" && {_x == count GVAR(lzwDictonary)}) then {
                _entry = _lastSequence + [_lastSequence select 0];
            };
            _bytes append _entry;
            if (!(_lastSequence isEqualTo [])) then {
                GVAR(lzwDictonary) pushBack (_lastSequence + [_entry select 0]);
            };
            _lastSequence = _entry;
            nil
        } count _rawInput;

        // convert to multi byte
        _rawOutput = _bytes call CFUNC(bytesToOrd); // TODO convert while decompressing not afterwards
    };
    default { // Not Compressed String
        LOG("Uncompressed string!")
        _rawOutput = _rawInput;
    };
};
DUMP(_rawOutput)
toString _rawOutput
