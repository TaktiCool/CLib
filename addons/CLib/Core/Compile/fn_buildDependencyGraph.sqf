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
    // DUMP("_i: " + str _i)
    DUMP("ModuleName: " + str _moduleName)
    private _dependencies = parsingNamespace getVariable (format [QCGVAR(%1_dependency), _moduleName]);


    if (_dependencies isEqualTo []) then {
        _sortedModuleNames pushBack _moduleName;
        _modulesToSort deleteAt _i;
        _i = _i mod ((count _modulesToSort) max 1);
    } else {
        private _dependenciesLoaded = true;
        {
            if !(_x in _sortedModuleNames) then {
                if !(_x in _modulesToSort) then {
                    private _str = format ["Missing Dependency in Module: %1, %2",_moduleName, _x];
                    LOG(_str)
                    _dependenciesLoaded = true;
                } else {
                    _dependenciesLoaded = false;
                };
            };
            if (!_dependenciesLoaded) exitWith {};
            nil
        } count _dependencies;

        if (_dependenciesLoaded) then {
            _sortedModuleNames pushBack _moduleName;
            _modulesToSort deleteAt _i;
            _i = _i mod ((count _modulesToSort) max 1);
        } else {
            _i = (_i + 1) mod (count _modulesToSort);
        };
    };
};

DUMP("Sorted Modules: " + str _sortedModuleNames)
parsingNamespace setVariable [QGVAR(allModuleNamesCached), _sortedModuleNames];
