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

#ifdef isDev
GVAR(maxFPS) = 0;

["missionStarted", {
    private _display = findDisplay 46;
    private _ctrlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", 9500];
    _ctrlGroup ctrlSetPosition [safeZoneX + safeZoneW - PX(13), 0.5 + PY(3.4), PX(12), PY(5)];
    _ctrlGroup ctrlCommit 0;

    private _control = _display ctrlCreate ["RscStructuredText", 9501, _ctrlGroup];
    _control ctrlSetPosition [PX(0), PY(0), PX(4), PY(1.5)];
    _control ctrlSetFont "PuristaMedium";
    _control ctrlCommit 0;

    for "_i" from 40 to 1 step -1 do {
        private _control = _display ctrlCreate ["RscPicture", 9501 + _i, _ctrlGroup];
        _control ctrlSetPosition [PX(4 + (0.2 * (_i - 1))), PY(0), PX(0.2), PY(5)];
        _control ctrlSetText "#(argb,8,8,3)color(1,1,1,1)";
        _control ctrlCommit 0;
    };

    [{
        params ["_display"];

        if (isNull _display) exitWith {};

        private _currentFPS = 1 / CGVAR(deltaTime);
        GVAR(maxFPS) = _currentFPS max GVAR(maxFPS);

        private _control = _display displayCtrl 9501;
        _control ctrlSetStructuredText parseText format ["<t align='right' size='%1'>%2</t>", PY(1.5)/0.035, round GVAR(maxFPS)];

        private _lastHeight = PY(5) * (_currentFPS / GVAR(maxFPS));
        private _maxHeight = 0;
        for "_i" from 40 to 1 step -1 do {
            private _control = _display displayCtrl (9501 + _i);
            private _position = ctrlPosition _control;
            private _height = _lastHeight;
            _lastHeight = _position select 3;
            _position set [1, PY(5) - _height];
            _position set [3, _height];
            _maxHeight = _maxHeight max _height;
            _control ctrlSetPosition _position;
            _control ctrlSetTextColor ([[1, 1, 1, 0.8], [1, 0, 0, 0.8]] select (_height < PY(2)));
            _control ctrlCommit 0;
        };

        if (PY(4) > _maxHeight) then {
            GVAR(maxFPS) = GVAR(maxFPS) * 0.8;
        };
    }, 0, _display] call CFUNC(addPerFrameHandler);
}] call CFUNC(addEventHandler);
#endif
