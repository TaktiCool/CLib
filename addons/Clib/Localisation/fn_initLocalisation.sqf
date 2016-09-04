#include "macros.hpp"
/*
    Project Reality ArmA 3

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
    LVAR(ServerNamespace) = false call CFUNC(createNamespace);

    LVAR(supportedLanguages) = getArray(configFile >> "CLib_Localisation" >> "supportedLanguages");

    {
        {
            private _currentConfig = _x;
            private _allLocalisations = [];
            {
                _allLocalisations set [_forEachIndex, getText (_currentConfig >> (["English", _x] select (isText (_currentConfig >> _x))))];
            } forEach LVAR(supportedLanguages);
            [LVAR(ServerNamespace), configName _x, _allLocalisations, QLVAR(allLocalisations)] call CFUNC(setVariable);
            nil
        } count configProperties [_x >> "CLib_Localisation", "isClass _x", true];
        nil
    } count [configFile, campaignConfigFile, missionConfigFile];


    [QLVAR(registerPlayer), {
        (_this select 0) params ["_language", "_player"];
        private _sendVariable = [];
        private _index = LVAR(supportedLanguages) find _language;
        if (_index == -1) then {
            _index = LVAR(supportedLanguages) find "English";
        };

        {
            private _var = (LVAR(ServerNamespace) getVariable _x) select _index;
            _sendVariable pushBack [_x, _var];
            nil
        } count ([LVAR(ServerNamespace), QLVAR(allLocalisations)] call CFUNC(allVariables));

        if (useCompression) then {
            _sendVariable = [(str _sendVariable), "LZW"] call CFUNC(compressString);
        };
        [QLVAR(receive), _player, _sendVariable] call CFUNC(targetEvent);
    }] call CFUNC(addEventhandler);
};

if (hasInterface) then {
    LVAR(ClientNamespace) = false call CFUNC(createNamespace);

    [QLVAR(registerPlayer), [language, CLib_Player]] call CFUNC(serverEvent);

    [QLVAR(receive), {
        params ["_localisationData"];
        if (_localisationData isEqualTo "") then {
            _localisationData = _localisationData call CFUNC(decompressString);
        };
        {
            [LVAR(ClientNamespace), _x select 0, _x select 1, QLVAR(all)] call CFUNC(setVariable);
            nil
        } count _localisationData;
    }] call CFUNC(addEventhandler);
};
