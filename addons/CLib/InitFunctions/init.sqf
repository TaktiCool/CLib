#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Fake function that calls and compiles init Functions because no PreProcessor is Available over the cfgFunctions entry

    Parameter(s):
    None

    Returns:
    None
*/
RUNTIMESTART;
if (getNumber (configFile >> "cfgFunctions" >> "version") == 3) then {
    private _initFunctionsArgs = _this;
    isNil {
        _initFunctionsArgs call compile preprocessFileLineNumbers "tc\CLib\addons\CLib\InitFunctions\initFunctions.sqf";
    };
} else {
    _this call compile preprocessFileLineNumbers "a3\functions_f\initfunctions.sqf";
};
RUNTIME("InitCompile");
