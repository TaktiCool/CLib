#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    try to get a Unit from a Unit Pool.

    Parameter(s):
    0: Requested Object Type <String>
    1: Time to be locked after use <Number>
    2: Unit Parameter
        0: Group <Group> (default: grpNull)
        1: Init Code executed on the unit <String, Code> (default: "")
        2: Skill <Number> (default: 0.5)
        3: Rank <String> (default: "PRIVATE")

    Returns:
    Requested Object <Object>
*/
params [["_unitClass", "", [""]], ["_lockedCondition", {}, [{}]], ["_unitParams", [grpNull, "", 0.5, "PRIVATE"]]];

private _varName = _unitClass + "_unit";

private _unitsData = GVAR(objPool) getVariable [_varName, [[-999, objNull]]];
private _unit = objNull;
{
    _x params ["_lockedCondition", "_obj"];
    if (alive _obj && !(call _lockedCondition)) then {
        _unitsData select _forEachIndex;
        _unit = _obj;
        breakTo SCRIPTSCOPENAME;
    };
} forEach _unitsData;
if (isNull _unit) then {
    private _params = [[0,0,0]];
    _params append _unitParams;
    _unit = _unitClass createUnit _params;
} else {
    _unitParams params [["_grp", grpNull], ["_init", ""], ["_skill", 0.5], ["_rank", "PRIVATE"]];
    [_unit] joinSilent _grp;
    if (_init isEqualType "") then {
        _init = compile _init;
    };
    _unit call _init;
    _unit setSkill _skill;
    _unit setRank _rank;
};

_unitsData pushBack [_lockedCondition, _unit];
_unitsData sort true;
GVAR(objPool) setVariable [_varName, _unitsData, true];
_unit
