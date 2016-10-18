#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    Client Init for Localisation

    Parameter(s):
    None

    Returns:
    None
*/

#ifdef disableCompression
    #define useCompression false
#else
    #define useCompression GVAR(useFunctionCompression)
#endif

if (isServer) then {
    GVAR(ServerNamespace) = true call CFUNC(createNamespace);
    GVAR(supportedLanguages) = getArray(configFile >> "CfgCLibLocalisation" >> "supportedLanguages");
    {
        {
            private _tagName = configName _x;
            {
                private _currentConfig = _x;
                private _allLocalisations = [];
                {
                    private _text = getText (_currentConfig >> (["English", _x] select (isText (_currentConfig >> _x))));
                    /* TODO Fix Compression
                    if (useCompression) then {
                        _text = [_text] call CFUNC(compressString);
                    };
                    */
                    _allLocalisations set [_forEachIndex, _text];
                } forEach GVAR(supportedLanguages);
                [GVAR(ServerNamespace), format ["STR_%1_%2", _tagName, configName _x], _allLocalisations, QGVAR(allLocalisations), true] call CFUNC(setVariable);
                nil
            } count configProperties [_x, "isClass _x", true];
            nil
        } count configProperties [_x >> "CfgCLibLocalisation", "isClass _x", true];
        nil
    } count [configFile, campaignConfigFile, missionConfigFile];
    publicVariable QGVAR(ServerNamespace);
    publicVariable QGVAR(supportedLanguages);
};

if (hasInterface) then {
    GVAR(ClientNamespace) = false call CFUNC(createNamespace);

    private _index = GVAR(supportedLanguages) find language;
    if (_index == -1) then {
        _index = GVAR(supportedLanguages) find "English";
    };
    {
        private _var = (GVAR(ServerNamespace) getVariable _x) select _index;
        /* TODO Fix Compression
        if (useCompression) then {
            _var = _var call CFUNC(decompressString);
        };
        */
        DUMP("L10N Varfound: " + _x + " Content: " + _var)
        [GVAR(ClientNamespace), _x, _var, QGVAR(all)] call CFUNC(setVariable);
        nil
    } count ([GVAR(ServerNamespace), QGVAR(allLocalisations)] call CFUNC(allVariables));
};
