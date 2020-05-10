#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Creates a two-option message box in a new dialogue.

    Parameter(s):
    0: Text <String, Text> (Default: "testText")
    1: Header <String> (Default: "header")
    2: Button 1 CallBack <Code, Array> (Default: {})
    3: Button 2 CallBack <Code, Array> (Default: {})
    4: OnClose <Code> (Default: {})
    5: Arguments <Anything> (Default: nil)

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_text", "testText", ["", text ""]],
    ["_header", "header", [""]],
    ["_button1Callback", {}, [{}, []], 2],
    ["_button2Callback", {}, [{}, []], 2],
    ["_onClose", {}, [{}]],
    "_args"
];

private _button1Text = "Ok";
private _button2Text = "Cancel";
if (_button1Callback isEqualType []) then {
    _button1Text = _button1Callback select 0;
    _button1Callback = _button1Callback select 1;
};
if (_button2Callback isEqualType []) then {
    _button2Text = _button2Callback select 0;
    _button2Callback = _button2Callback select 1;
};
if (_text isEqualType "") then {
    _text = text _text;
};
if (isNil QFUNC(MessageBoxCallback)) then {
    DFUNC(MessageBoxCallback) = [{
        params [["_display", displayNull], "_typeName"];
        if (isNull _display && isNil "_typeName") exitWith {};
        private _args = _display getVariable QGVAR(Arguments);
        private _callBack = _display getVariable [_typeName, {}];
        _args call _callBack;
    }] call CFUNC(compileFinal);
};
if !(createDialog "RscDisplayCommonMessage") exitWith {
    LOG("ERROR Display not Created");
};
[{
    params ["_button1Text", "_button2Text", "_text", "_header", "_button1Callback", "_button2Callback", "_onClose", "_args"];

    private _display = uiNamespace getVariable ["RscDisplayCommonMessage_display", displayNull];

    private _ctrlRscMessageBox = _display displayctrl 2351;
    private _ctrlBcgCommonTop = _display displayctrl 235100;
    private _ctrlBcgCommon = _display displayctrl 235101;
    private _ctrlText = _display displayctrl 235102;
    private _ctrlBackgroundButtonOK = _display displayctrl 235103;
    private _ctrlBackgroundButtonMiddle = _display displayctrl 235104;
    private _ctrlBackgroundButtonCancel = _display displayctrl 235105;
    private _ctrlButtonOK = _display displayctrl 235106;
    private _ctrlButtonCancel = _display displayctrl 235107;

    //--- Calculate spacing
    private _ctrlButtonOKPos = ctrlPosition _ctrlButtonOK;
    private _ctrlBcgCommonPos = ctrlPosition _ctrlBcgCommon;
    private _bottomSpaceY = (_ctrlButtonOKPos select 1) - ((_ctrlBcgCommonPos select 1) + (_ctrlBcgCommonPos select 3));

    //--- Calculate text padding
    private _ctrlTextPos = ctrlPosition _ctrlText;
    private _marginX = (_ctrlTextPos select 0) - (_ctrlBcgCommonPos select 0);
    private _marginY = (_ctrlTextPos select 1) - (_ctrlBcgCommonPos select 1);

    //--- Apply text and get its height
    _ctrlText ctrlSetStructuredText _text;
    private _ctrlTextPosH = ctrlTextHeight _ctrlText;

    //--- Move text area
    _ctrlBcgCommon ctrlSetPosition [
        (_ctrlBcgCommonPos select 0),
        (_ctrlBcgCommonPos select 1),
        (_ctrlBcgCommonPos select 2),
        _ctrlTextPosH + (_marginY * 2)
    ];
    _ctrlBcgCommon ctrlCommit 0;

    _ctrlText ctrlSetPosition [
        (_ctrlBcgCommonPos select 0) + _marginX,
        (_ctrlBcgCommonPos select 1) + _marginY,
        (_ctrlBcgCommonPos select 2) - _marginX * 2,
        _ctrlTextPosH
    ];
    _ctrlText ctrlCommit 0;

    //--- Move bottom bar
    private _bottomPosY = (_ctrlBcgCommonPos select 1) + _ctrlTextPosH + (_marginY * 2) + _bottomSpaceY;
    {
        private _xPos = ctrlPosition _x;
        _xPos set [1, _bottomPosY];
        _x ctrlSetPosition _xPos;
        _x ctrlCommit 0;
    } foreach [
        _ctrlBackgroundButtonOK,
        _ctrlBackgroundButtonMiddle,
        _ctrlBackgroundButtonCancel,
        _ctrlButtonOK,
        _ctrlButtonCancel
    ];

    //--- Move the whole group
    private _ctrlRscMessageBoxPosH = _bottomPosY + (_ctrlButtonOKPos select 3);
    _ctrlRscMessageBox ctrlSetPosition [
        0.5 - (_ctrlBcgCommonPos select 2) / 2,
        0.5 - _ctrlRscMessageBoxPosH / 2,
        (_ctrlBcgCommonPos select 2) + 0.5,
        _ctrlRscMessageBoxPosH
    ];
    _ctrlRscMessageBox ctrlEnable true;
    _ctrlRscMessageBox ctrlCommit 0;

    //--- Set buttons visibility and text
    private _focus = _ctrlButtonOK;
    _ctrlButtonOK ctrlEnable true;
    _ctrlButtonOK ctrlSetFade 0;
    _ctrlButtonOK ctrlSetText _button1Text;
    _ctrlButtonOK ctrlCommit 0;

    _ctrlButtonCancel ctrlEnable true;
    _ctrlButtonCancel ctrlSetFade 0;
    _ctrlButtonCancel ctrlSetText _button2Text;
    _ctrlButtonCancel ctrlCommit 0;
    ctrlSetFocus _focus;

    _ctrlBcgCommonTop ctrlSetText _header;

    _display setVariable [QGVAR(Arguments), _args];
    _display setVariable [QGVAR(callBack_Button1), _button1Callback];
    _display setVariable [QGVAR(callBack_Button2), _button2Callback];
    _display setVariable [QGVAR(callBack_onClose), _onClose];

    _display displayAddEventHandler ["Unload", {
        params ["_display", "_exitCode"];
        if (_exitCode isEqualTo 2) then {
            [_display, QGVAR(callBack_onClose)] call FUNC(MessageBoxCallback);
        };
    }];

    _ctrlButtonOK ctrlAddEventHandler ["buttonClick", {
        [ctrlParent (_this select 0), QGVAR(callBack_Button1)] call FUNC(MessageBoxCallback);
    }];

    _ctrlButtonCancel ctrlAddEventHandler ["buttonClick", {
        [ctrlParent (_this select 0), QGVAR(callBack_Button2)] call FUNC(MessageBoxCallback);
    }];
}, {
    !isNull (uiNamespace getVariable ["RscDisplayCommonMessage_display", displayNull])
}, [_button1Text, _button2Text, _text, _header, _button1Callback, _button2Callback, _onClose, _args]] call CFUNC(waitUntil);
