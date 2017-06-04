#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas, NetFusion

    Description:
    Client init of performance info.

    Parameter(s):
    None

    Returns:
    None
*/

#ifdef ISDEV
    #define FRAMECOUNT 40
    GVAR(topFPS) = 0;
    GVAR(FPSStorage) = [];
    GVAR(FPSStorage) resize FRAMECOUNT;
    GVAR(FPSStorage) = GVAR(FPSStorage) apply {0};

    ["missionStarted", {
        // Create all controls
        private _display = findDisplay 46;
        private _ctrlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", 9500];
        _ctrlGroup ctrlSetPosition [safeZoneX + safeZoneW - PX(FRAMECOUNT * 0.2 + 5), 0.5 + PY(3.4), PX(FRAMECOUNT * 0.2 + 4), PY(5)];
        _ctrlGroup ctrlCommit 0;

        private _control = _display ctrlCreate ["RscStructuredText", 9501, _ctrlGroup];
        _control ctrlSetPosition [PX(0), PY(0), PX(4), PY(1.5)];
        _control ctrlSetFont "PuristaMedium";
        _control ctrlCommit 0;

        for "_i" from 0 to (FRAMECOUNT - 1) do {
            private _control = _display ctrlCreate ["RscPicture", 9502 + _i, _ctrlGroup];
            _control ctrlSetPosition [PX(_i * 0.2 + 4), PY(0), PX(0.2), PY(5)];
            _control ctrlSetText "#(argb,8,8,3)color(1,1,1,1)";
            _control ctrlCommit 0;
        };

        // Create the PFH
        [{
            params ["_display"];

            if (isNull _display) exitWith {};

            private _currentFPS = 1 / CGVAR(deltaTime);
            GVAR(topFPS) = _currentFPS max GVAR(topFPS);

            GVAR(FPSStorage) deleteAt 0;
            GVAR(FPSStorage) pushBack _currentFPS;

            private _prevFrameFPS = 0;
            private _maxFPS = 0;
            for "_i" from 0 to (FRAMECOUNT - 1) do {
                private _control = _display displayCtrl (9502 + _i);
                private _position = ctrlPosition _control;
                private _frameFPS = GVAR(FPSStorage) select _i;
                _maxFPS = _frameFPS max _maxFPS;
                private _height = _frameFPS / GVAR(topFPS) * PY(5);
                _position set [1, PY(5) - _height];
                _position set [3, _height];
                _control ctrlSetPosition _position;
                _control ctrlSetTextColor ([[1, 1, 1, 0.8], [1, 0, 0, 0.8]] select (_frameFPS < _prevFrameFPS * 0.7));
                _control ctrlCommit 0;
                _prevFrameFPS = _frameFPS;
            };

            if (_maxFPS < GVAR(topFPS) * 0.7) then {
                GVAR(topFPS) = GVAR(topFPS) * 0.8;
            };

            (_display displayCtrl 9501) ctrlSetStructuredText parseText format ["<t align='right' size='%1'>%2</t>", PY(1.5) / 0.035, round GVAR(topFPS)];
        }, 0, _display] call CFUNC(addPerFrameHandler);
    }] call CFUNC(addEventHandler);
#endif
