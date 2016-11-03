#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    LZW decompression of a String

    Parameter(s):
    0: compressed string <String>

    Returns:
    0: uncompressed <String>
*/
#define SYMBOL_OFFSET 256
params ["_decompressedString"];
private _output = "";

private _compressedArray = toArray _decompressedString;

private _compression = (_compressedArray deleteAt 0);

switch (_compression) do {
    case 1: { //LZ77
        {
            if (_x < 1024) then {
                _output = _output + toString [_x];
            } else {
                private _length = floor (_x/1024);
                private _offset = _x - (_length*1024);
                _output = _output + (_output select [((count _output) - 1025 + _offset) max _offset, _length+1]);
            };
            nil
        } count _compressedArray;
    };
    case 2: { // LZW
        if (isNil QGVAR(CompressionDictionary)) then {
            GVAR(CompressionDictionary) = [];
            for "_i" from 0 to (SYMBOL_OFFSET-1) do {
                GVAR(CompressionDictionary)  pushBack toString [_i];
            };
        };
        private _dict = +GVAR(CompressionDictionary);
        private _buffer = "";
        {
            private _nbrDict = count _dict;
            private _currentWord = "";
            if (_x < _nbrDict) then {
                _currentWord = _dict select _x;
                if (_buffer != "") then {
                    _dict set [_nbrDict, _buffer + (_currentWord select [0,1])];
                };
            } else {
                _currentWord = _buffer + (_buffer select [0,1]);
                _dict set [_x,_currentWord];
            };
            _buffer = _currentWord;
            _output = _output + _currentWord;
            nil
        } count _compressedArray;
    };
    default { // Not Compressed String
        LOG("String is not Compressed!")
        _output = _decompressedString;
    };
};


_output;
