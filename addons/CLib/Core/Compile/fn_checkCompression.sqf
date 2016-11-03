#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Check if all Compression work right

    Parameter(s):
    0: UnCompressed String <String>

    Returns:
    fail Compression <Array< LZ77, LZW>>
*/
params ["_string"];

private _return = [];
{
    private _compressedFunction = [_string , _x] call CFUNC(compressString);
    private _decompFunction = _compressedFunction call CFUNC(decompressString);
    if !(_decompFunction isEqualTo _string) then {
        _return pushBack true;
    } else {
        _return pushBack false;
    };
    nil
} count AllCompressionTypes;
_return
