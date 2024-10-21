#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Get a unit from a unit pool

    Parameter(s):
    0: Requested Object Type <String> (Default: "")
    1: Locked condition <Code> (Default: {false})
    2: Unit Parameter <Array> (Default: [grpNull, "", 0.5, "PRIVATE"])

    Returns:
    Requested Object <Object>

    Remarks:
    Unit parameter structure:
        0: Group <Group> (Default: grpNull)
        1: Init Code executed on the unit <String, Code> (Default: "")
        2: Skill <Number> (Default: 0.5)
        3: Rank <String> (Default: "PRIVATE")
*/

params [
    ["_unitClass", "", [""]],
    ["_condition", {false}, [{}]],
    ["_unitParams", [grpNull, {}, 0.5, "PRIVATE"], [[]]]
];

private _varName = _unitClass + "_unit";

private _unitsData = GVAR(objPool) getVariable [_varName, [[-999, objNull]]];
private _unit = objNull;
{
    _x params ["_lockedCondition", "_obj"];
    if (alive _obj && !(call _lockedCondition)) then {
        _unitsData deleteAt _forEachIndex;
        _unit = _obj;
        breakTo SCRIPTSCOPENAME;
    };
} forEach _unitsData;
_unitParams params [["_grp", grpNull], ["_init", {}], ["_skill", 0.5], ["_rank", "PRIVATE"]];
if (isNull _unit) then {
    _unit = _grp createUnit [_unitClass, [0, 0, 0], [], 0, "NONE"];
} else {
    [_unit] joinSilent _grp;
    _unit setDamage 0;
    _unit allowDamage true;
    ["enableSimulation", [_unit, true]] call CFUNC(serverEvent);
};
if (_init isEqualType "") then {
    _init = compile _init;
};

_unit call _init;
_unit setSkill _skill;
_unit setRank _rank;

_unitsData pushBack [_condition, _unit];
GVAR(objPool) setVariable [_varName, _unitsData, true];
_unit
