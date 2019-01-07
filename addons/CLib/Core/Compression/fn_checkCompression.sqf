#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if all compression types work properly

    Parameter(s):
    0: UnCompressed String <String>

    Returns:
    Whether the compression has worked properly <Boolean>
*/

params ["_string"];

private _compressedFunction = _string call CFUNC(compressString);
private _decompFunction = _compressedFunction call CFUNC(decompressString);

_decompFunction isEqualTo _string
