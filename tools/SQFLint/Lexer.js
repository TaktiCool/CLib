/*
    DO NOT USE WITHOUT EXCLUSIVE PERMISSION

    Community Lib - CLib

    Author: NetFusion

    Description:
    Lexer class for SQFLint
*/

const fs = require('fs');
const path = require('path');

const Error = require('./Error');
const Token = require('./Token');

class Lexer {
    static lex(input, filename) {
        const lexer = new Lexer(input, filename);
        return lexer.getTokens();
    }

    constructor(input, filename) {
        if (typeof input != 'string') return console.error('Expected source code to be a string but got "' + typeof input + '"');

        this.input = input.replace(/\r/g, '');
        this.filename = filename;
        this.originalInput = this.input;
        this.lineNumber = 1;
        this.columnNumber = 1;
        this.ended = false;
        this.tokens = [];
        this.indentStack = [0];
    }

    error(format) {
        const args = arguments;
        const message = format.replace(/{(\d+)}/g, (match, number) => {
            return args[parseInt(number) + 1];
        });
        new Error(message, this.filename, this.lineNumber, this.columnNumber, this.originalInput);
    }

    fail() {
        this.error('Unexpected text {0}', this.input.substr(0, 5));
        this.ended = true;
        return true;
    }

    getTokens() {
        while (!this.ended) {
            this.advance();
        }
        return this.tokens;
    }

    advance() {
        return this.isTokenBlank()
            || this.isTokenEos()
            || this.isTokenIndent()
            || this.isTokenSpace()
            || this.isTokenInclude()
            || this.isTokenDefine()
            || this.isTokenIfDef()
            || this.isTokenElse()
            || this.isTokenEndIf()
            || this.isTokenLineComment()
            || this.isTokenBlockComment()
            || this.isTokenMacro()
            || this.isTokenCommand()
            || this.isTokenVariable()
            || this.isTokenString()
            || this.isTokenNumber()
            || this.isTokenArrayStart()
            || this.isTokenArraySeparator()
            || this.isTokenArrayEnd()
            || this.isTokenSemicolon()
            || this.isTokenOpenParentheses()
            || this.isTokenClosingParentheses()
            || this.isTokenOpenBracket()
            || this.isTokenClosingBracket()
            || this.isTokenAssignment()
            || this.isTokenOperator()
            || this.isTokenColon()
            || this.isTokenNegation()
            || this.fail();
    }

    token(type, value) {
        return new Token(type, this.lineNumber, this.columnNumber, value);
    }

    incrementLine(number) {
        this.lineNumber += number;
        if (number) this.columnNumber = 1;
    }

    incrementColumn(number) {
        this.columnNumber += number;
    }

    consume(length) {
        this.input = this.input.substr(length);
    }

    scan(pattern, type) {
        const matches = pattern.exec(this.input);
        if (matches) {
            const length = matches[0].length;
            const value = matches[1];
            const diff = length - (value ? value.length : 0);
            const token = this.token(type, value);
            this.consume(length);
            this.incrementColumn(diff);
            return token;
        }
    }

    scanEndOfLine(pattern, type) {
        const matches = pattern.exec(this.input);
        if (matches) {
            const newInput = this.input.substr(matches[0].length);
            if (/^(\n|$)/.test(newInput)) {
                this.input = newInput;
                const token = this.token(type, matches[1]);
                this.incrementLine(matches[0].split('\n').length - 1);
                this.incrementColumn(matches[0].length);
                return token;
            }
        }
    }

    isTokenBlank() {
        const matches = /^\n[ \t]*\n/.exec(this.input);
        if (matches) {
            this.consume(matches[0].length - 1);
            this.incrementLine(1);
            return true;
        }
    }

    isTokenEos() {
        if (this.input.length) return;

        this.tokens.push(this.token('eos'));
        this.ended = true;
        return true;
    }

    isTokenIndent() {
        const matches = /^\n((    )*)/.exec(this.input);
        if (matches) {
            const indents = matches[1].length;

            this.incrementLine(1);
            this.consume(indents + 1);

            // Outdent
            if (indents < this.indentStack[0]) {
                while (this.indentStack[0] > indents) {
                    if (this.indentStack[1] < indents)
                        this.error('Inconsistent indentation. Expecting either {0} or {1} spaces', this.indentStack[1], this.indentStack[0]);
                    this.columnNumber = this.indentStack[1] + 1;
                    this.tokens.push(this.token('outdent'));
                    this.indentStack.shift();
                }
            // Indent
            } else if (indents != this.indentStack[0]) {
                this.tokens.push(this.token('indent', indents));
                this.columnNumber = 1 + indents;
                this.indentStack.unshift(indents);
            } else {
                this.tokens.push(this.token('newline'));
                this.columnNumber = 1 + (this.indentStack[0] || 0);
            }

            return true;
        }
    }

    isTokenSpace() {
        const token = this.scan(/^ /, 'space');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenInclude() {
        const token = this.scanEndOfLine(/^#include "(.*)"/, 'include');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenDefine() {
        const token = this.scanEndOfLine(/^#define ([A-Z][A-Z_]*) .+/, 'define');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenIfDef() {
        const token = this.scanEndOfLine(/^#ifn?def ([A-Z][A-Z_]*)/, 'ifDef');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenElse() {
        const token = this.scanEndOfLine(/^#else/, 'else');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenEndIf() {
        const token = this.scanEndOfLine(/^#endif/, 'endIf');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenLineComment() {
        const token = this.scanEndOfLine(/^ ?\/\/([^\n]*)/, 'lineComment');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenBlockComment() {
        const token = this.scanEndOfLine(/^\/\*[\s\S]*?\*\//, 'blockComment');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenMacro() {
        const token = this.scan(/^([A-Z][A-Z_]*[A-Z])(?![a-zA-Z_])/, 'macro');
        if (token) {
            if (this.input[0] == '(') {
                this.consume(1);

                let macroArguments = '(';
                let parenthesesCounter = 0;
                while (this.input.length && this.input[0] != ')' || parenthesesCounter > 0) {
                    if (this.input[0] == '(') {
                        parenthesesCounter++;
                        this.consume(1);
                    } else if (this.input[0] == ')') {
                        parenthesesCounter--;
                        this.consume(1);
                    } else {
                        const matches = /^"(([^"]|"")*)"/.exec(this.input);
                        if (matches) {
                            this.consume(matches[0].length);
                            macroArguments += matches[0];
                        } else {
                            macroArguments += this.input[0];
                            this.consume(1);
                        }
                    }
                }
                this.consume(1);
                macroArguments += ')';

                token.value += macroArguments;
            }

            this.tokens.push(token);
            if (token.value) this.incrementColumn(token.value.length);
            return true;
        }
    }

    isTokenCommand() {
        const token = this.scan(/^(([a-z]|A(G|S|T)LTo)[a-zA-Z0-9_]*)/, 'command');
        if (token && token.value.indexOf('_fnc_') == -1) {
            this.tokens.push(token);
            this.incrementColumn(token.value.length);
            return true;
        }
    }

    isTokenVariable() {
        const token = this.scan(/^(_?[a-zA-Z][a-zA-Z0-9_]*)/, 'variable');
        if (token) {
            this.tokens.push(token);
            this.incrementColumn(token.value.length);
            return true;
        }
    }

    isTokenString() {
        const token = this.scan(/^"(([^"]|"")*)"/, 'string');
        if (token) {
            this.tokens.push(token);
            this.incrementLine(token.value.split('\n').length - 1);
            this.incrementColumn(token.value.lastIndexOf('\n') > -1 ? token.value.length - token.value.lastIndexOf('\n') : token.value.length);
            return true;
        }
    }

    isTokenNumber() {
        const token = this.scan(/^(-?\d+\.?\d*)(?![a-z])/, 'number');
        if (token) {
            this.tokens.push(token);
            this.incrementColumn(token.value.length);
            return true;
        }
    }

    isTokenArrayStart() {
        const token = this.scan(/^\[/, 'arrayStart');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenArraySeparator() {
        const token = this.scan(/^,/, 'arraySeparator');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenArrayEnd() {
        const token = this.scan(/^]/, 'arrayEnd');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenSemicolon() {
        const token = this.scan(/^;/, 'semicolon');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenOpenParentheses() {
        const token = this.scan(/^\(/, 'openParentheses');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenClosingParentheses() {
        const token = this.scan(/^\)/, 'closingParentheses');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenOpenBracket() {
        const token = this.scan(/^\{/, 'openBracket');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenClosingBracket() {
        const token = this.scan(/^}/, 'closingBracket');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenAssignment() {
        const token = this.scan(/^= /, 'assignment');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenOperator() {
        const token = this.scan(/^((>>|==|!=|>=|<=|>|<|\|\||&&|\+|-|\*|\/|\^|%)(?=\s)|\+)/, 'operator');
        if (token) {
            this.tokens.push(token);
            this.incrementColumn(token.value.length);
            return true;
        }
    }

    isTokenColon() {
        const token = this.scan(/^:/, 'colon');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }

    isTokenNegation() {
        const token = this.scan(/^!/, 'negation');
        if (token) {
            this.tokens.push(token);
            return true;
        }
    }
}

module.exports = Lexer;