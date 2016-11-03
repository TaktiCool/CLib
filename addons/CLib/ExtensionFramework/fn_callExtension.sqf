#include "macros.hpp"
/*
    Community Lib - CLib

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

"CLib" callExtension "frameworkClear";

{
    "CLib" callExtension _x;
    nil
} count _splitOutput;

"CLib" callExtension _action;

private _finalReturn = "";
// endless Loop to prevent running in the max 10k rounds that every other loop in arma can run
private _fnc_fetchOutput = {
    private _return = "CLib" callExtension "frameworkImport";
    if (_return isEqualTo "Done") then {
        "CLib" callExtension "frameworkClear";
        _finalReturn
    } else {
        _finalReturn = _finalReturn + _return;
        call _fnc_fetchOutput;
    };
};
call _fnc_fetchOutput;
