#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Hold Action Handler

    Parameter(s):
    0: Target <Object, String, Array> (Default: objNull)
    1: Title <String> (Default: "MISSING TITLE")
    2: Idle icon <String, Code> (Default: "MISSING ICON")
    3: Progress icon <String, Code> (Default: "MISSING ICON")
    4: Show condition <Code> (Default: {true})
    5: Progress condition <Code> (Default: {true})
    6: Start code <Code> (Default: {})
    7: Progress code <Code> (Default: {})
    8: Completed code <Code> (Default: {})
    9: Interrupted code <Code> (Default: {})
    10: Arguments <Any> (Default: [])
    11: Priority <Number> (Default: 1000)
    12: Remove on complete <Bool> (Default: true)
    13: Show unconscious <Bool> (Default: false)
    14: Ignored canInteract conditions <Array> (Default: [])
    15: Selection <String> (Default: "")
    16: Memorypoint <String> (Default: "")

    Returns:
    None

    Example:
    [cursorTarget, "TestHold", "", "", {true}, {true}, {StartTime = time;}, {(time - StartTime)/10},{hint "COMPLETED";},{hint "INTERRUPTED"}] call CLib_fnc_addHoldAction;
*/

params [
    ["_target", objNull, [objNull, "", []], []],
    ["_title", "MISSING TITLE", [""]],
    ["_iconIdle", "MISSING ICON", ["", {}]],
    ["_iconProgress", "MISSING ICON", ["", {}]],
    ["_condShow", {true}, [{}]],
    ["_condProgress", {true}, [{}]],
    ["_codeStart", {}, [{}]],
    ["_codeProgress", {}, [{}]],
    ["_codeCompleted", {}, [{}]],
    ["_codeInterrupted", {}, [{}]],
    ["_arguments", [], []],
    ["_priority", 1000, [0]],
    ["_removeCompleted", true, [true]],
    ["_showUnconscious", false, [true]],
    ["_ignoredCanInteractConditions", [], [[]], []],
    ["_selection", "", [""]],
    ["_memorypoint", "", [""]]
];

//preprocess data
private _keyNameRaw = actionKeysNames ["Action", 1, "Keyboard"];
private _keyName = _keyNameRaw select [1, count _keyNameRaw - 2];
private _keyNameColored = format ["<t color='#ffae00'>%1</t>", _keyName];
private _hint = format [localize "STR_A3_HoldKeyTo", _keyNameColored, _title];
_hint = format ["<t font='RobotoCondensedBold'>%1</t>", _hint];

if (_iconIdle isEqualType "") then {
    _iconIdle = compile format ["""%1""", _iconIdle];
};

if (_iconProgress isEqualType "") then {
    _iconProgress = compile format ["""%1""", _iconProgress];
};

if (_target isEqualType "" && {_target == "VanillaAction"}) then {
    [_title, {
        _this call FUNC(holdActionCallback);
        true
    }, [
        _title,
        _hint,
        _iconIdle,
        _iconProgress,
        _condShow,
        _condProgress,
        _codeStart,
        _codeProgress,
        _codeCompleted,
        _codeInterrupted,
        _arguments,
        _priority,
        _removeCompleted,
        _showUnconscious,
        _ignoredCanInteractConditions,
        _selection,
        _memorypoint
    ]] call CFUNC(overrideAction);
} else {
    _title = format ["<t color='#FFFFFF' align='left'>%1</t>        <t color='#83ffffff' align='right'>%2     </t>", _title, _keyName];
    _condShow = compile format ["if (_this call %1) then {[""%2"", %3, ""%4""] call " + QFUNC(IdleAnimation) + "; true;} else {false};", _condShow, _title, _iconIdle, _hint];
    [_title, _target, 0, _condShow, FUNC(holdActionCallback), ["arguments", [
        _title,
        _hint,
        _iconIdle,
        _iconProgress,
        _condShow,
        _condProgress,
        _codeStart,
        _codeProgress,
        _codeCompleted,
        _codeInterrupted,
        _arguments,
        _priority,
        _removeCompleted,
        _showUnconscious,
        _ignoredCanInteractConditions,
        _selection,
        _memorypoint
    ], "priority", _priority, "showWindow", true, "hideOnUse", false, "unconscious", _showUnconscious, "selection", _selection, "memorypoint", _memorypoint, "onActionAdded", {
        params ["_id", "_target", "_argArray"];
        _argArray params ["", "", "_args"];
        _args params [
            "_title",
            "_hint",
            "_iconIdle",
            "_iconProgress",
            "_condShow",
            "_condProgress",
            "_codeStart",
            "_codeProgress",
            "_codeCompleted",
            "_codeInterrupted",
            "_arguments",
            "_priority",
            "_removeCompleted",
            "_showUnconscious",
            "_ignoredCanInteractConditions",
            "_selection",
            "_memorypoint"
        ];

        _target setUserActionText [_id, _title, "<img size='3' shadow='0' color='#ffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_0_ca.paa'/><br/><br/>" + _hint, format ["<img size='3' shadow='0' color='#ffffffff' image='%1'/>", (call _iconIdle)]];
    }, "ignoredCanInteractConditions", _ignoredCanInteractConditions]] call CFUNC(addAction);
};
