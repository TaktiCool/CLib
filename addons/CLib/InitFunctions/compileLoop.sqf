/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: Karel Moricky, Killzone_Kid
    a3\functions_f\initFunctions.sqf

    Description:
    -

    Parameter(s):
    None

    Returns:
    None
*/

private _currentItem = _x;

//--- Is Item
if (isClass _currentItem) then {
    // private ["_itemVar","_itemCompile","_itemPreInit","_itemPostInit","_itemPreStart","_itemRecompile","_itemCheatsEnabled"];

    //--- Read function
    private _itemName = configName _currentItem;
    private _itemPathItem = getText (_currentItem >> "file");
    private _itemExt = getText (_currentItem >> "ext");
    private _itemPreInit = getNumber (_currentItem >> "preInit");
    private _itemPostInit = getNumber (_currentItem >> "postInit");
    private _itemPreStart = getNumber (_currentItem >> "preStart");
    private _itemRecompile = getNumber (_currentItem >> "recompile");
    private _itemCheatsEnabled = getNumber (_currentItem >> "cheatsEnabled");
    if (_itemExt == "") then {_itemExt = ".sqf"};
    private _itemPath = if (_itemPathItem != "") then {
        if (_tagName == "BIS" && _pathAccess == 0) then {
            //--- Disable rewriting of global BIS functions from outside (ToDo: Make it dynamic, so anyone can protect their functions)
            private _itemPathItemA3 = (tolower _itemPathItem) find "a3";
            private _itemPathSlash = (tolower _itemPathItem) find "\";
            if ((_itemPathItemA3 < 0 || _itemPathItemA3 > 1) && _itemPathSlash > 0) then {_itemPathItem = "";};
        };
        _itemPathItem
    } else {
        ""
    };
    if (_itemPath == "") then {
        _itemPath = if (_itemPathCat != "") then {_itemPathCat + "\fn_" + _itemName + _itemExt} else {
            if (_itemPathTag != "") then {_itemPathTag + "\fn_" + _itemName + _itemExt} else {""};
        };
    };
    private _itemHeader = getNumber (_currentItem >> "headerType");

    //--- Compile function
    if (_itemPath == "") then {_itemPath = _pathFile + "\" + _categoryName + "\fn_" + _itemName + _itemExt};
    private _itemVar = _tagName + "_fnc_" + _itemName;
    private _itemMeta = [_itemPath, _itemExt, _itemHeader, _itemPreInit > 0, _itemPostInit > 0, _itemRecompile> 0, _tag, _categoryName, _itemName];
    private _itemCompile = if (_itemCheatsEnabled == 0 || (_itemCheatsEnabled > 0 && cheatsEnabled)) then {
        [_itemVar, _itemMeta, _itemHeader, _compileFinal] call _fncCompile;
    } else {
        compilefinal "false" //--- Function not available in retail version
    };

    //--- Register function
    if (_itemCompile isEqualType {}) then {
        if !(_itemVar in _functions_list) then {
            private ["_namespaces"];
            _namespaces = if (_pathAccess == 0) then {[uiNamespace]} else {[missionNamespace]};
            {
                //---- Save function
                _x setVariable [
                    _itemVar,
                    _itemCompile
                ];
                //--- Save function meta data
                _x setVariable [
                    _itemVar + "_meta",
                    compileFinal str _itemMeta
                ];
                nil;
            } count _namespaces;
            if (_pathAccess == 0) then {
                _functions_list pushBack _itemVar;
                nil;
            };
        };

        //--- Add to list of functions executed upon mission start
        if (_itemPreInit > 0) then {
            _functions_listPreInitAccess = _functions_listPreInit select _pathAccess;
            if !(_itemVar in _functions_listPreInitAccess) then {
                _functions_listPreInitAccess pushBack _itemVar;
            };
        };
        if (_itemPostInit > 0) then {
            _functions_listPostInitAccess = _functions_listPostInit select _pathAccess;
            if !(_itemVar in _functions_listPostInitAccess) then {
                _functions_listPostInitAccess pushBack _itemVar;
                nil;
            };
        };

        //--- Add to list of functions executed upon game start
        if (_itemPreStart > 0) then {
            if (_pathAccess == 0) then {
                if !(_itemVar in _functions_listPreStart) then {
                    _functions_listPreStart pushBack _itemVar;
                    nil;
                };
            } else {
                private _errorFnc = uiNamespace getVariable "BIS_fnc_error";
                private _errorText = "%1 is a mission / campaign function and cannot contain 'preStart = 1;' param";
                if (isNil "_errorFnc") then {
                    diag_log format ["Log: [Functions]: " + _errorText,_itemVar];
                } else {
                    [_errorText, _itemVar] call _errorFnc;
                };
            };
        };

        //--- Add to list of functions recompiled upon mission start
        if (_itemRecompile > 0) then {
            if (_pathAccess == 0) then {
                if !(_itemVar in _functions_listRecompile) then {
                    _functions_listRecompile pushBack _itemVar;
                };
            } else {
                private _errorFnc = uiNamespace getVariable "BIS_fnc_error";
                private _errorText = "Redundant use of 'recompile = 1;' in %1 - mission / campaign functions are recompiled on start by default.";
                if (isNil "_errorFnc") then  {
                    diag_log format ["Log: [Functions]: " + _errorText,_itemVar];
                } else {
                    [_errorText,_itemVar] call _errorFnc;
                };
            };
        };

        //if (_itemRecompile > 0) then {
        //    _functions_listRecompileAccess = _functions_listRecompile select _pathAccess;
        //    _functions_listRecompileAccess set [count _functions_listRecompileAccess,_itemVar];
        //};
        //--- Debug
        //debuglog ["Log:::::::::::::::::::Function",_itemVar,_itemPath,_pathAccess];
    };
};
