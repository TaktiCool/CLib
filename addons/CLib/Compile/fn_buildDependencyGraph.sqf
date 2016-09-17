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
private _modulesToSort = +GVAR(allModuleNamesCached);

private _i = 0;
while {!(_modulesToSort isEqualTo [])} do {
    private _moduleName = _modulesToSort select _i;
    private _dependencies = parsingNamespace getVariable [format [QGVAR(%1_dependency), _moduleName], []];

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
        };
    };
};

GVAR(allModuleNamesCached) = _sortedModuleNames;