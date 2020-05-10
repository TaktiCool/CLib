/*
 DO NOT USE WITHOUT EXCLUSIVE PERMISSION

 SQFLint
 Author: NetFusion
 https://github.com/netfusion/SQFLint

 Description:
 Parser class for SQFLint
 */

const Error = require('./error');
const Token = require('./token');

class Parser {
    static parse(tokens, filename, content) {
        const parser = new Parser(tokens, filename, content);
        try {
            parser.parseCode('eos');
        } catch (e) {
            if (e instanceof Error) return 1;
            throw e;
        }
        return 0;
    }

    constructor(tokens, filename, content) {
        if (!Array.isArray(tokens)) return console.error('Expected tokens code to be a array but got "' + typeof tokens + '"');

        this.tokens = tokens.slice();
        this.filename = filename;
        this.content = content;

        this.nularCommands = require('./../lang/nular-commands');
        this.unaryCommands = require('./../lang/unary-commands');
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
        return this.tokens[n] || new Token('eos');
    }

    expect(types, errorMessage) {
        if (!Array.isArray(types)) types = [types];
        if (types.indexOf(this.peek().type) >= 0) return this.tokens.shift();
        this.error(errorMessage || 'Expected {0} but got {1}', types.join(', '), this.peek().type);
    }

    parseCode(scopeTerminator) {
        // code ::= ((commentFullLine | preprocessor | statement | macro) NEWLINE)*

        while (this.peek().type !== scopeTerminator) {
            if (this.peek().type === 'preprocessor-start') {
                this.tokens.shift();
                switch (this.peek().type) {
                    case 'preprocessor-include':
                    case 'preprocessor-define':
                        this.tokens.shift();
                        break;
                    case 'preprocessor-if':
                        this.tokens.shift();
                        this.expect('indent');
                        this.parseCode('outdent');
                        this.expect('outdent');
                        this.expect('preprocessor-start');
                        if (this.peek().type === 'preprocessor-else') {
                            this.tokens.shift();
                            this.expect('indent');
                            this.parseCode('outdent');
                            this.expect('outdent');
                            this.expect('preprocessor-start');
                        }
                        this.expect('preprocessor-endIf');
                        break;
                    default:
                        this.error('Unexpected preprocessor command: {0}', this.peek().type);
                }
            } else if (['lineComment', 'blockComment'].indexOf(this.peek().type) >= 0) {
                this.tokens.shift();
            } else if (this.peek().type === 'macro' && (this.lookahead(1).type === 'newline' && this.lookahead(2).type !== 'logical-operator') || this.lookahead(1).type === 'blank') {
                this.tokens.shift();
            } else {
                this.parseStatement(scopeTerminator);
            }

            if (this.peek().type !== scopeTerminator || scopeTerminator === 'eos') {
                if (this.peek().type === 'blank')
                    this.tokens.shift();
                this.expect('newline');
            }
        }
    }

    parseStatement(scopeTerminator) {
        // statement ::= (assignStatement | expression) SEMICOLON commentEndOfLine?

        if (this.tokens.length > 4 && (this.peek().type === 'command' && this.peek().value === 'private' && this.lookahead(4).type === 'assignment-operator')  // private _variable =
            || this.lookahead(2).type === 'assignment-operator') // _variable =
            this.parseAssignment();
        else
            this.parseExpression();

        if (['space', scopeTerminator].indexOf(this.peek().type) >= 0 || (scopeTerminator === 'eos' && this.lookahead(1).type === 'eos' && this.peek().type === 'newline')) {
            if (this.peek().type === 'space') {
                this.tokens.shift();
                this.expect('lineComment');
            }
            return;
        }

        this.expect('semicolon');
        if (this.peek().type === 'space') {
            this.tokens.shift();
            this.expect('lineComment');
        }
    }
    parseAssignment() {
        // assignStatement ::= (COMMAND_PRIVATE SPACE)? (macroCall | VARIABLE) SPACE ASSIGNMENT_OPERATOR SPACE expression

        if (this.peek().type === 'command' && this.peek().value === 'private') {
            this.tokens.shift();
            this.expect('space');
        }
        this.expect(['macro', 'variable']);
        this.expect('space');
        this.expect('assignment-operator');
        this.expect('space');
        this.parseExpression();
    }

    parseExpression() {
        // expression ::= primaryExpression (((SPACE operator) | COLON | (commentEndOfLine? NEWLINE SPACE LOGICAL_OPERATOR)) SPACE expression)?

        this.parsePrimaryExpression();

        if (
            this.peek().type === 'colon'
            || (this.lookahead(1).type !== 'eos' && this.peek().type === 'newline')
            || (
                this.peek().type === 'space'
                && (
                    this.lookahead(1).type !== 'lineComment'
                    || (
                        this.lookahead(2).type === 'newline'
                        && this.lookahead(3).type === 'space'
                        && this.lookahead(4).type === 'logical-operator'
                    )
                )
            )
        ) {
            switch (this.peek().type) {
                case 'space':
                    this.tokens.shift();
                    if (this.peek().type === 'lineComment') {
                        this.tokens.shift();
                        this.expect('newline');
                        this.expect('space');
                        this.expect('logical-operator');
                    } else {
                        this.parseOperator();
                    }
                    break;
                case 'colon':
                    this.tokens.shift();
                    break;
                case 'newline':
                    this.tokens.shift();
                    this.expect('space');
                    this.expect('logical-operator');
                    break;
            }
            this.expect('space');
            this.parseExpression();
        }
    }
    parsePrimaryExpression() {
        // primaryExpression ::= unaryExpression | nularExpression | NUMBER | STRING | braces

        if (['unary-arithmetic-operator', 'unary-logical-operator', 'macro', 'command', 'variable', 'left-parentheses', 'left-bracket'].indexOf(this.peek().type) >= 0) {
            let lookahead = 1;
            if (['unary-arithmetic-operator', 'unary-logical-operator'].indexOf(this.peek().type) >= 0) lookahead = 2;
            if (this.lookahead(lookahead).type === 'space' && ['macro', 'command', 'variable', 'left-parentheses', 'left-bracket', 'number', 'string', 'left-brace', 'unary-logical-operator'].indexOf(this.lookahead(lookahead + 1).type) >= 0)
                this.parseUnaryExpression();
            else
                this.parseNularExpression();
        } else if (['number', 'string'].indexOf(this.peek().type) >= 0) {
            this.tokens.shift();
        } else if (this.peek().type === 'left-brace') {
            this.parseBraces();
        } else {
            this.error('Unexpected token in primary expression: {0}', this.peek().type);
        }
    }
    parseUnaryExpression() {
        // unaryExpression ::= nularExpression SPACE primaryExpression

        this.parseNularExpression();
        this.expect('space');
        this.parsePrimaryExpression();
    }
    parseNularExpression() {
        // nularExpression ::= (UNARY_ARITHMETIC_OPERATOR | UNARY_LOGICAL_OPERATOR)? (macro | command | VARIABLE | parentheses | array)

        if (['unary-logical-operator', 'unary-arithmetic-operator'].indexOf(this.peek().type) >= 0) {
            this.expect(this.peek().type);
        }

        switch (this.peek().type) {
            case 'macro':
            case 'command':
            case 'variable':
                this.tokens.shift();
                break;
            case 'left-parentheses':
                this.parseParentheses();
                break;
            case 'left-bracket':
                this.parseArray();
                break;
            default:
                this.error('Unexpected token in nular expression: {0}', this.peek().type);
        }
    }

    parseOperator() {
        // operator ::= command | CONFIG_OPERATOR | UNARY_ARITHMETIC_OPERATOR | ARITHMETIC_OPERATOR | LOGICAL_OPERATOR | COMPARISON_OPERATOR

        this.expect(['command', 'config-operator', 'unary-arithmetic-operator', 'arithmetic-operator', 'logical-operator', 'comparison-operator']);

    }

    parseArray() {
        // LBRACKET (
        //     (expression (COMMA SPACE expression)*) |
        //     (INDENT expression (COMMA ((commentEndOfLine? NEWLINE) | SPACE) expression)* commentEndOfLine? OUTDENT)
        // )? RBRACKET

        this.expect('left-bracket');

        if (this.peek().type === 'indent') {
            this.tokens.shift();
            this.parseExpression();
            while (this.peek().type === 'comma') {
                this.tokens.shift();
                if (this.peek().type === 'space' && this.lookahead(1).type !== 'lineComment') {
                    this.tokens.shift();
                } else {
                    if (this.peek().type === 'space') {
                        this.tokens.shift();
                        this.expect('lineComment');
                    }
                    this.expect('newline');
                }
                this.parseExpression();
            }
            if (this.peek().type === 'space') {
                this.tokens.shift();
                this.expect('lineComment');
            }
            this.expect('outdent');
        } else if (this.peek().type !== 'right-bracket') {
            this.parseExpression();
            while (this.peek().type === 'comma') {
                this.tokens.shift();
                this.expect('space');
                this.parseExpression();
            }
        }

        this.expect('right-bracket');
    }
    parseParentheses() {
        // parentheses ::= LPAREN expression RPAREN

        this.expect('left-parentheses');
        this.parseExpression();
        this.expect('right-parentheses');
    }
    parseBraces() {
        // braces ::= LBRACE ((commentEndOfLine? INDENT code returnStatement OUTDENT) | ((statement SPACE)* expression))? RBRACE

        this.expect('left-brace');
        if (this.peek().type === 'space') {
            this.tokens.shift();
            this.expect('lineComment');
        }

        if (this.peek().type === 'indent') {
            this.tokens.shift();
            this.parseCode('outdent');
            this.expect('outdent');
        } else if (this.peek().type !== 'right-brace') {
            //while (this.peek().type != 'right-brace') {
            do {
                if (this.lookahead(2).type === 'assignment-operator')
                    this.parseAssignment();
                else
                    this.parseExpression();
            } while (this.peek().type === 'semicolon' && this.tokens.shift() && this.expect('space'));
        }

        this.expect('right-brace');
    }
}

module.exports = Parser;