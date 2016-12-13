#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Converts a character ordinal to its UTF bytes according to FFS-UTF proposal from 1992.
    See https://puu.sh/sJEaj/f28cce9242.png
    THIS IS NOT UTF-8!!!

    Parameter(s):
    0: unicode value <Number>

    Returns:
    0: array of bytes <Array>
*/

params ["_ord"];

private _bytes = [_ord]; // assume the default ascii representation
if (_ord > 127) then { // non-ascii character => convert to utf bytes
    private _additionalBytes = switch (true) do { // number of additional bytes needed
        case (_ord < 4096): {1}; // Less than 13 bits => we can pack it in 2 bytes
        default {2}; // Arma3 maximum value is 65535 (check if toString [65536] returns something) so it less than 17 bits => we can pack it in 3 bytes
    };
    private _firstByte = floor (_ord / (2 ^ (_additionalBytes * 6))); // first byte always begins with 1 bit, right-shift for (_additionalBytes * 7) bits
    for "_i" from (_additionalBytes - 1) to 0 step -1 do { // for each additional byte
        _firstByte = _firstByte + (2 ^ (7 - _i)); // set the (7 - _i) bit of the first byte to 1
        _bytes pushBack ((floor (_ord / (2 ^ (_i * 6)) % 64) * 2) + 1); // push additional byte in form of 0xxxxxx1
    };
    _bytes set [0, _firstByte]; // replace the first byte with the new one
};

_bytes