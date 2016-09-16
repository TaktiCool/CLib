#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    Check a Function and Return the Dependencys

    Parameter(s):
    0: Function Name <String>

    Returns:
    Dependencys <Array>
*/
params [["_fncCode", "", [{}, ""]]];
if (_fncCode isEqualType "") then {
    _fncCode = parsingNamespace getVariable _fncCode;
};

_fncCode = str(_fncCode);
_fncCode = _fncCode select [1, count _fncCode - 2];

private _return = [];
{
    if (_x find _fncCode) then {
        private _data = parsingNamespace getVariable _x + "_data";
        _data params ["", "", "", "", "_modName", "_moduleName"];
        private _module = format ["%1/%2", _modName, _modName];
        _return pushBackUnique _module;
    };
    nil
} count CGVAR(functionCache);

_return
