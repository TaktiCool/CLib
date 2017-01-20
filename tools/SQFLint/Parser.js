/*
    DO NOT USE WITHOUT EXCLUSIVE PERMISSION

    Community Lib - CLib

    Author: NetFusion

    Description:
    Parser class for SQFLint
 */

const Error = require('./Error');

class Parser {
    static parse(tokens, filename, content) {
        const parser = new Parser(tokens, filename, content);
        try {
            parser.parseCode('eos');
        } catch (e) {
            return 1;
        };
        return 0;
    }

    constructor(tokens, filename, content) {
        if (!Array.isArray(tokens)) return console.error('Expected tokens code to be a array but got "' + typeof tokens + '"');

        this.tokens = tokens;
        this.filename = filename;
        this.content = content;

        this.requireSemicolon = true;
        this.inWhile = false;

        this.nularCommands = require('./Lang/NularCommands');
        this.unaryCommands = require('./Lang/UnaryCommands');
    }

    error(format) {
        const args = arguments;
        const message = format.replace(/{(\d+)}/g, (match, number) => {
            return args[parseInt(number) + 1];
        });
        throw new Error(message, this.filename, this.peek().lineNumber, this.peek().columnNumber, this.content);
    }

    peek() {
        return this.tokens[0];
    }

    lookahead(n) {
        return this.tokens[n];
    }

    expect(type) {
        if (this.peek().type == type) return this.tokens.shift();
        this.error('Expected {0} but got {1}', type, this.peek().type);
    }

    parseCode(terminator, indented = false) {
        this.parseNonCode();
        if (this.peek().type == terminator) return; // Empty
        this.parseStatement();
        while (this.peek().type != terminator) {
            if (this.peek().type == 'space' && this.lookahead(1).type == 'lineComment') {
                this.expect('space');
                this.expect('lineComment');
            }
            if (indented && this.peek().type == 'outdent') { // Return value without semicolon
                this.requireSemicolon = true;
                this.expect('outdent');
                break;
            } else if (this.peek().type == 'newline' && this.lookahead(1).type == 'eos') { // Empty line at end of file
                break;
            }
            this.parseSemicolon();
            if (this.peek().type == 'outdent' && indented) { // No return value
                this.expect('outdent');
                break;
            }

            this.parseNonCode();
            if (this.peek().type != terminator)
                this.parseStatement();
        }

        if (this.peek().type == 'outdent' && indented) this.expect('outdent');
    }

    parseNonCode() {
        while (['include', 'lineComment', 'blockComment'].indexOf(this.peek().type) > -1) {
            switch (this.peek().type) {
                case 'include':
                    this.expect('include');
                    break;
                case 'lineComment':
                    this.expect('lineComment');
                    break;
                case 'blockComment':
                    this.expect('blockComment');
                    break;
            }
            if (this.peek().type == 'outdent') {
                this.expect('outdent');
                break;
            }
            this.expect('newline');
        }
    }

    parseStatement() {
        if (this.tokens.length > 4
            && (this.peek().type == 'command' && this.peek().value == 'private' && this.lookahead(4).type == 'assignment')  // private _variable =
            || ((this.peek().type == 'variable' || this.peek().type == 'macro') && this.lookahead(2).type == 'assignment')  // _variable =
        )
            this.parseAssignment();
        else
            this.parseBinaryExpression();
    }

    parseAssignment() {
        if (this.peek().type == 'command' && this.peek().value == 'private') {
            this.expect('command');
            this.expect('space');
        }

        if (this.peek().type == 'macro') {
            this.expect('macro');
        } else {
            this.expect('variable');
        }
        this.expect('space');
        this.expect('assignment');
        this.parseBinaryExpression();
    }

    parseBinaryExpression() {
        if (this.peek().type == 'operator' && this.peek().value == '+') // Create copy of array
            this.expect('operator');

        this.parsePrimaryExpression();

        if (this.tokens.length > 2 && this.peek().type == 'newline' && this.lookahead(2).type == 'operator' && ['&&', '||'].indexOf(this.lookahead(2).value) > -1) {
            this.expect('newline');
        }

        if (this.peek().type == 'space' && this.lookahead(1).type != 'lineComment') {
            this.expect('space');
            this.parseOperator();
            this.expect('space');
            this.parseBinaryExpression();
        }

        if (this.peek().type == 'colon') { // Only inside do
            this.expect('colon');
            this.expect('space');
            this.parseBinaryExpression();
        }
    }

    parsePrimaryExpression() {
        if (this.peek().type == 'negation')
            this.expect('negation');

        switch (this.peek().type) {
            case 'define':
                this.requireSemicolon = false;
                return this.expect('define');
            case 'ifDef':
                this.expect('ifDef');
                this.expect('indent');
                this.parseCode('outdent', true);
                if (this.peek().type == 'else') {
                    this.expect('else');
                    this.expect('indent');
                    this.parseCode('outdent', true);
                }
                this.requireSemicolon = false;
                return this.expect('endIf');
            case 'macro':
                if (this.tokens.length > 2 && this.lookahead(1).type == 'space' && this.lookahead(2).type == 'variable') return this.parseUnaryExpression();
                const token = this.expect('macro');
                if (token.value[token.value.length - 1] != ')' && this.peek().type == 'newline') this.requireSemicolon = false;
                return;
            case 'command':
                if (this.nularCommands.indexOf(this.peek().value) > -1) return this.parseNularExpression();
                if (this.unaryCommands.indexOf(this.peek().value) > -1) return this.parseUnaryExpression();
                this.error('Wrong argument count for command: {0}', this.peek().value);
            case 'number':
            case 'variable':
            case 'string':
                return this.expect(this.peek().type);
            case 'openBracket':
                return this.parseOpenBracket();
            case 'openParentheses':
                return this.parseOpenParentheses();
            case 'arrayStart':
                return this.parseArray();
            default: this.error('Unexpected token in expression: {0}', this.peek().type);
        }
    }

    parseUnaryExpression() {
        this.parseOperator();
        this.expect('space');
        this.parsePrimaryExpression();
    }

    parseNularExpression() {
        this.parseOperator();
    }

    parseOperator() {
        if (this.peek().type == 'macro') {
            return this.expect('macro');
        } else if (this.peek().type == 'command') {
            if (this.peek().value == 'while') this.inWhile = true;
            return this.expect('command');
        } else if (this.peek().type == 'operator') {
            return this.expect('operator');
        }

        this.error('Unexpected token as operator: {0}', this.peek().type);
    }

    parseArray() {
        this.expect('arrayStart');

        let indented = false;
        if (this.peek().type != 'arrayEnd') {
            if (this.peek().type == 'indent') {
                indented = true;
                this.expect('indent');
            }

            this.parseBinaryExpression();
            while (this.peek().type == 'arraySeparator') {
                this.expect('arraySeparator');
                if (indented && this.lookahead(1).type == 'lineComment') {
                    this.expect('space');
                    this.expect('lineComment');
                    this.expect('newline');
                } else if (this.peek().type == 'space') {
                    this.expect('space');
                } else if (indented) {
                    this.expect('newline');
                }

                this.parseBinaryExpression();
            }

            if (indented && this.lookahead(1).type == 'lineComment') {
                this.expect('space');
                this.expect('lineComment');
            }
        }

        if (indented) this.expect('outdent');
        this.expect('arrayEnd');
    }

    parseSemicolon() {
        if (!this.requireSemicolon) {
            this.expect('newline');
            this.requireSemicolon = true;
            return;
        }
        this.expect('semicolon');

        switch (this.peek().type) {
            case 'outdent':
                // Handled by parseCode
                break;
            case 'space':
                this.expect('space');
                if (this.inWhile) return;
                this.expect('lineComment');
                if (this.peek().type == 'outdent') return; // Handled by parseCode
                this.expect('newline');
                break;
            case 'newline':
                this.expect('newline');
                break;
            default:
                this.error('Unexpected token after semicolon: {0}', this.peek().type);
        }
    }

    parseOpenParentheses() {
        this.expect('openParentheses');
        this.parseBinaryExpression();
        this.expect('closingParentheses');
    }

    parseOpenBracket() {
        this.expect('openBracket');

        if (this.peek().type == 'space') {
            this.expect('space');
            this.expect('lineComment');
        }

        let indented = false;
        if (this.peek().type != 'closingBracket') {
            if (this.peek().type == 'indent') {
                indented = true;
                this.expect('indent');
            }

            this.parseCode('closingBracket', indented, this.inWhile);
        }

        this.expect('closingBracket');
        if (this.inWhile) this.inWhile = false;
    }
}

module.exports = Parser;