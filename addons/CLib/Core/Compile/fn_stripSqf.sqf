#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Strips all whitespaces and lower case all variables in code

    Parameter(s):
    0: input <String>

    Returns:
    0: output <String>
*/
params [["_inputStr",""]];

private _sqString = false;
private _dqString = false;
private _inPreProcessor = false;
private _lastC = 0;
private _whiteSpaces = toArray ' '+ [10, 13];
private _operator = toArray '+-*/%&|<>=:,;';
private _braces = toArray '(){}[]"''';
private _allSpecialChar = _whiteSpaces + _operator + _braces;
private _operatorAndBraces = _operator + _braces;
private _token = [];
private _outStr = '';

{
    if (_sqString || _dqString || _inPreProcessor) then {
        if (_dqString && {_x == 34} && {_lastC != 34}) then {
            _dqString = false;
        };
        if (_sqString && {_x == 39} && {_lastC != 39}) then {
            _sqString = false;
        };
        if (_inPreProcessor && {_x == 10} && {_lastC != 92}) then {
            _inPreProcessor = false;
        };
        _outStr = _outStr + toString [_x];
        _lastC = _x;
    } else {
        _dqString = _x == 34;
        _sqString = _x == 39;
        _inPreProcessor = _x == 35;
        if (_sqString || _dqString || _inPreProcessor) then {
            if (_inPreProcessor) then {
                _outStr = _outStr + toString [10];
            };
            _outStr = _outStr + toString [_x];
            _lastC = 0;
        } else {
            if (_x in _allSpecialChar) then {
                _outStr = _outStr + toLower toString _token;
                _token = [];
                if (_x in _operatorAndBraces) then {
                    _outStr = _outStr + toString [_x];
                    _lastC = _x;
                };
            } else {
                if (_token isEqualTo [] && _lastC>0 && !(_lastC in _operatorAndBraces)) then {
                    _outStr = _outStr + ' ';
                };
                _lastC = _x;
                _token pushBack _x;
            };
        };
    };
    nil
} count toArray _inputStr;

_outStr = _outStr + toLower toString _token;
_outStr
