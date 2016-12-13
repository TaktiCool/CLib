#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Converts a byte array to character values according to

    Parameter(s):
    0: bytes array <Array>

    Returns:
    0: array of character ordinal <Array>
*/

params ["_bytes"];
if (_bytes isEqualType 0) then {
    _bytes = _this;
};

private _ordArray = [];
private _ord = 0;
private _additionalBytes = 0;
{
    if (_additionalBytes > 0 || _x > 127) then { // UTF character byte
        if (_additionalBytes == 0) then { // This is the first byte of character
            _additionalBytes = switch (true) do { // How many bits are 1 (from left)
                case (_x < 192): {1}; // 10xxxxxx => packed in 2 bytes
                default {2}; // Arma3 maximum value is 65535 (check if toString [65536] returns something) so it less than 17 bits => packed in 3 bytes
            };
            _ord = (_x % (2 ^ (8 - _additionalBytes))) * (2 ^ (_additionalBytes * 6)); // Read value bits from byte and left shift depending on _bytesForOrd
        } else {
            _additionalBytes = _additionalBytes - 1;
            _ord = _ord + ((floor (_x / 2)) * (2 ^ (_additionalBytes * 6))); // Byte in form of 0xxxxxx1
        };
        if (_additionalBytes == 0) then {
            _ordArray pushBack _ord;
            _ord = 0;
        };
    } else {
        _ordArray pushBack _x; // Normal ascii character
    };
    nil
} count _bytes;

_ordArray