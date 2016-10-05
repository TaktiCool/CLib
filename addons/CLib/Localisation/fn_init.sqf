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
    GVAR(ServerNamespace) = false call CFUNC(createNamespace);

    GVAR(supportedLanguages) = getArray(configFile >> "CfgCLibLocalisation" >> "supportedLanguages");

    {
        {
            private _currentConfig = _x;
            private _allLocalisations = [];
            {
                _allLocalisations set [_forEachIndex, getText (_currentConfig >> (["English", _x] select (isText (_currentConfig >> _x))))];
            } forEach GVAR(supportedLanguages);
            [GVAR(ServerNamespace), configName _x, _allLocalisations, QGVAR(allLocalisations)] call CFUNC(setVariable);
            nil
        } count configProperties [_x >> "CfgCLibLocalisation", "isClass _x", true];
        nil
    } count [configFile, campaignConfigFile, missionConfigFile];


    [QGVAR(registerPlayer), {
        (_this select 0) params ["_language", "_player"];
        private _sendVariable = [];
        private _index = GVAR(supportedLanguages) find _language;
        if (_index == -1) then {
            _index = GVAR(supportedLanguages) find "English";
        };

        {
            private _var = (GVAR(ServerNamespace) getVariable _x) select _index;
            _sendVariable pushBack [_x, _var];
            nil
        } count ([GVAR(ServerNamespace), QGVAR(allLocalisations)] call CFUNC(allVariables));
        /*
        if (useCompression) then {
            _sendVariable = [(str _sendVariable), "LZW"] call CFUNC(compressString);
        };
        */
        [QGVAR(receive), owner _player, _sendVariable] call CFUNC(targetEvent);
    }] call CFUNC(addEventhandler);
};

if (hasInterface) then {
    GVAR(ClientNamespace) = false call CFUNC(createNamespace);

    [QGVAR(registerPlayer), [language, CLib_Player]] call CFUNC(serverEvent);

    [QGVAR(receive), {
        params ["_localisationData"];
        if (_localisationData isEqualTo "") then {
            _localisationData = _localisationData call CFUNC(decompressString);
        };
        {
            [GVAR(ClientNamespace), _x select 0, _x select 1, QGVAR(all)] call CFUNC(setVariable);
            nil
        } count _localisationData;
    }] call CFUNC(addEventhandler);
};
