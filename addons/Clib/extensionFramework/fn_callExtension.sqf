#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: joko // Jonas

    Description:
    call Extension Direct and return the Value

    Parameter(s):
    0: Action <String>
    1: Data <String> (default: "")

    Returns:
    Stichted Extension Return <String>
*/

params [["_action", "Error", [""]], ["_data", "", [""]]];

private _splitOutput = _data call CFUNC(splitOutputString);

"Clib" callExtension "frameworkClear";

{
    "Clib" callExtension _x;
    nil
} count _splitOutput;

"Clib" callExtension _action;

private _finalReturn = "";
// endless Loop to prevent running in the max 10k rounds that every other loop in arma can run
private _fnc_fetchOutput = {
    private _return = "Clib" callExtension "frameworkImport";
    if (_return isEqualTo "Done") then {
        "Clib" callExtension "frameworkClear";
        _finalReturn
    } else {
        _finalReturn = _finalReturn + _return;
        call _fnc_fetchOutput;
    };
};
call _fnc_fetchOutput;
