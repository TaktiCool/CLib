/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Fake Function that call and Compile initFunctions because no PreProcessor is Avable over the cfgFunctions >> init entry

    Parameter(s):
    None

    Returns:
    None
*/
_this call compile preprocessFileLineNumbers "x\CLib\addons\CLib\initFunctions.sqf";
//_this call compile preprocessFileLineNumbers "A3\functions_f\initFunctions.sqf";
