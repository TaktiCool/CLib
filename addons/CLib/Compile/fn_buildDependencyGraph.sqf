#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Build dependency graph to determine loading order. Sort functions according to graph.

    Parameter(s):
    None

    Returns:
    None
*/
private _sortedModuleNames = [];
private _modulesToSort = +(parsingNamespace getVariable QGVAR(allModuleNamesCached));

private _i = 0;
DUMP("Modules To Sort: " + str _modulesToSort)
while {!(_modulesToSort isEqualTo [])} do {

    private _moduleName = _modulesToSort select _i;
    private _str = format ["_i: %1 ModuleName: %2", _i, _moduleName];
    DUMP(_str)
    private _dependencies = parsingNamespace getVariable [format [QGVAR(%1_dependency), _moduleName], nil];
    if (isNil "_dependencies") then {
        private _str = format ["Missing module: %1", _moduleName];
        LOG(_str)
    };

    if (_dependencies isEqualTo []) then {
        _sortedModuleNames pushBack _moduleName;
        _modulesToSort deleteAt _i;
    } else {
        private _dependenciesLoaded = true;
        {
            if (!(_x in _sortedModuleNames)) exitWith {
                _dependenciesLoaded = false;
            };
            nil
        } count _dependencies;

        if (_dependenciesLoaded) then {
            _sortedModuleNames pushBack _moduleName;
            _modulesToSort deleteAt _i;
        } else {
            _i = (_i + 1) % (count _modulesToSort);
            DUMP("_i2: " + str _i)
        };
    };
};

parsingNamespace setVariable [QGVAR(allModuleNamesCached), _sortedModuleNames];
