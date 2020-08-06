/*
 DO NOT USE WITHOUT EXCLUSIVE PERMISSION

 SQFLint
 Author: NetFusion
 https://github.com/netfusion/SQFLint

 Description:
 Parser class for SQFLint
 */

const Error = require('./error');
const Parser = require('./parser');

const projectTitle = 'Community Lib - CLib';
const authors = ['BadGuy', 'joko // Jonas', 'NetFusion'];
const allowedTypes = ['Any', 'Anything', 'Array', 'Bool', 'Code', 'Config', 'Control', 'Display', 'Group', 'Location', 'Namespace', 'Number', 'Object', 'Side', 'String', 'Task', 'Text'];

class LayoutChecker extends Parser {
    static checkLayout(tokens, filename, content) {
        const layoutChecker = new LayoutChecker(tokens, filename, content);
        try {
            layoutChecker.check();
        } catch (e) {
            if (e instanceof Error) return 1;
            throw e;
        }
        return 0;
    }

    check() {
        this.expect('preprocessor-start');
        const macroInclude = this.expect('preprocessor-include');
        if (macroInclude.value !== 'macros.hpp') this.error('Unknown include path: {0}', macroInclude.value);
        this.expect('newline');
        const fileHeaderToken = this.expect('blockComment');
        const fileHeader = this.parseHeader(fileHeaderToken);
        this.expect('blank');
        this.expect('newline');
        if (this.peek().type === 'macro' && this.peek().value === 'EXEC_ONLY_UNSCHEDULED') {
            this.expect('macro');
            this.expect('semicolon');
            this.expect('blank');
            this.expect('newline');
        }
        if (this.peek().type === 'command' && this.peek().value === 'params') {
            if (!fileHeader.parameter.length) this.error('Missing parameters in header');
            this.tokens.shift();
            this.expect('space');
            this.expect('left-bracket');
            this.expect('indent', 'Indent the parameter for readability');
            fileHeader.parameter.forEach((param, index) => {
                if (param.types.indexOf('Anything') === -1) {
                    this.expect('left-bracket', 'Missing type check for parameter');
                    param.variable = this.expect('string');
                    this.expect('comma');
                    this.expect('space');
                    param.default = this.parseExpression();
                    this.expect('comma', 'Missing type check for parameter');
                    this.expect('space');
                    this.expect('left-bracket');
                    param.types.forEach((type, index) => {
                        let command;
                        switch (type) {
                            case 'Array':
                                this.expect('left-bracket', 'Type array in header, check for []');
                                this.expect('right-bracket');
                                break;
                            case 'Bool':
                                command = this.expect('command');
                                if (command.value !== 'true')
                                    this.error('Type bool in header, check for true');
                                break;
                            case 'Code':
                                this.expect('left-brace', 'Type code in header, check for {}');
                                this.expect('right-brace');
                                break;
                            case 'Config':
                                command = this.expect('command');
                                if (command.value !== 'configNull')
                                    this.error('Type config in header, check for configNull');
                                break;
                            case 'Control':
                                command = this.expect('command');
                                if (command.value !== 'controlNull')
                                    this.error('Type control in header, check for controlNull');
                                break;
                            case 'Display':
                                command = this.expect('command');
                                if (command.value !== 'displayNull')
                                    this.error('Type display in header, check for displayNull');
                                break;
                            case 'Group':
                                command = this.expect('command');
                                if (command.value !== 'grpNull')
                                    this.error('Type group in header, check for grpNull');
                                break;
                            case 'Namespace':
                                command = this.expect('command');
                                if (command.value !== 'missionNamespace')
                                    this.error('Type namespace in header, check for missionNamespace');
                                break;
                            case 'Number':
                                command = this.expect('number');
                                if (command.value !== '0')
                                    this.error('Type number in header, check for 0');
                                break;
                            case 'Location':
                                command = this.expect('command');
                                if (command.value !== 'locationNull')
                                    this.error('Type location in header, check for locationNull');
                                break;
                            case 'Object':
                                command = this.expect('command');
                                if (command.value !== 'objNull')
                                    this.error('Type object in header, check for objNull');
                                break;
                            case 'Side':
                                command = this.expect('command');
                                if (command.value !== 'sideUnknown')
                                    this.error('Type side in header, check for sideUnknown');
                                break;
                            case 'String':
                                command = this.expect('string');
                                if (command.value !== '')
                                    this.error('Type string in header, check for empty string');
                                break;
                            case 'Task':
                                command = this.expect('command');
                                if (command.value !== 'taskNull')
                                    this.error('Type side in header, check for taskNull');
                                break;
                            case 'Text':
                                command = this.expect('command');
                                if (command.value !== 'text')
                                    this.error('Type text in header, check for text ""');
                                command = this.expect('space');
                                command = this.expect('string');
                                break;
                        }
                        if (index === param.types.length - 1)
                            return;
                        this.expect('comma', 'Parameter has more types in header');
                        this.expect('space');
                    });
                    this.expect('right-bracket');
                    if (param.types.indexOf('Array') >= 0) {
                        this.expect('comma', 'Add array size check');
                        this.expect('space');
                        if (this.peek().type === 'left-bracket') {
                            this.parseArray();
                        } else {
                            this.expect('number');
                        }
                    }
                    this.expect('right-bracket');
                } else {
                    param.variable = this.expect('string');
                }

                if (index === fileHeader.parameter.length - 1)
                    return;
                this.expect('comma', 'Header has more parameters');
                this.expect('newline');
            });
            this.expect('outdent', 'Missing parameter in header');
            this.expect('right-bracket');
            this.expect('semicolon');
            this.expect('blank');
        } else if (fileHeader.parameter.length) {
            this.error('Parameters in header not used');
        }

    }

    parseHeader(headerToken) {
        let text = headerToken.value;
        let lineNumber = headerToken.lineNumber;
        const header = {};

        // Project title
        let matches = new RegExp('^\n    ' + projectTitle + '\n').exec(text);
        if (!matches)
            throw new Error('Invalid project title', this.filename, lineNumber + 1, 1, this.content);
        text = text.substr(matches[0].length);
        lineNumber += 2;

        // Authors
        matches = new RegExp('^\n    Author: ((?:' + authors.join('|') + ')(?:, (?:' + authors.join('|') + '))*)\n').exec(text);
        if (!matches)
            throw new Error('Invalid authors', this.filename, lineNumber + 1, 1, this.content);
        header.authors = matches[1].split(', ');
        text = text.substr(matches[0].length);
        lineNumber += 2;

        // Original authors
        matches = /^\n    Original author: ([\w\/]+( [\w\/]+)*(?:, [\w\/]+( [\w\/]+)*)*)\n/.exec(text);
        if (matches) {
            header.originalAuthors = matches[1].split(', ');
            text = text.substr(matches[0].length);
            lineNumber += 2;
            matches = /^    (https?:\/\/(?:[-a-zA-Z0-9@:%._\\+~#=]{2,256}\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\.[a-z]{2,6}\b(?:[-a-zA-Z0-9@:%_\\+.~#?&/=]*))\n/.exec(text);
            if (!matches) {
                matches = /^    (a3\/\w+(\/\w+)*\.sqf)\n/.exec(text);
                if (!matches)
                    throw new Error('Invalid origin source link', this.filename, lineNumber, 1, this.content);
            }
            header.originSourceLink = matches[1];
            text = text.substr(matches[0].length);
            lineNumber += 1;
        }

        // Description
        matches = /^\n    Description:(\n    ([A-Z]\w+(?:(?:\.?\s|-)(?:\w+|"\w[\w/]+\w"))*\.?))+\n/.exec(text);
        if (!matches)
            throw new Error('Invalid description', this.filename, lineNumber + 1, 1, this.content);
        header.description = matches[1];
        text = text.substr(matches[0].length);
        lineNumber += 3;

        // Parameter
        matches = /^\n    Parameter\(s\):/.exec(text);
        if (!matches)
            throw new Error('Missing parameters', this.filename, lineNumber + 1, 1, this.content);
        header.parameter = [];
        text = text.substr(matches[0].length);
        lineNumber += 1;
        matches = /^\n    None\n/.exec(text);
        if (!matches) {
            matches = /^\n    (https?:\/\/(?:[a-zA-Z0-9@:%.-_\\+~#=]{2,256}\.)?[a-zA-Z0-9@:%.-_\\+~#=]{2,256}\.[a-z]{2,6}\b(?:[-a-zA-Z0-9@:%_\\+.~#?&/=]*))\n/.exec(text);
            if (!matches) {
                do {
                    matches = new RegExp('^\n    (\\d+): ([A-Z]\\w+(?:\\s\\w+)*) <((?:' + allowedTypes.join('|') + ')(?:, (?:' + allowedTypes.join('|') + '))*)> \\(Default: (.+)\\)').exec(text);
                    if (!matches || parseInt(matches[1]) !== header.parameter.length) {
                        throw new Error('Invalid parameter definition', this.filename, lineNumber + 1, 5, this.content);
                    }
                    header.parameter.push({
                        description: matches[2],
                        types: matches[3].split(', '),
                        default: matches[4]
                    });
                    text = text.substr(matches[0].length);
                    lineNumber++;
                } while (!/^\n\n/.test(text));
                text = text.substr(1);
            } else {
                text = text.substr(matches[0].length);
                lineNumber++;
            }
        } else {
            text = text.substr(matches[0].length);
        }
        lineNumber++;

        // Returns
        matches = /^\n    Returns:/.exec(text);
        if (!matches)
            throw new Error('Missing returns', this.filename, lineNumber + 1, 1, this.content);
        header.returns = null;
        text = text.substr(matches[0].length);
        lineNumber += 1;
        matches = /^\n    None\n/.exec(text);
        if (!matches) {
            matches = new RegExp('^\n    ([A-Z]\\w+(?:\\s\\w+)*) <((?:' + allowedTypes.join('|') + ')(?:, (?:' + allowedTypes.join('|') + '))*)>').exec(text);
            if (!matches) {
                throw new Error('Invalid returns definition', this.filename, lineNumber + 1, 5, this.content);
            }
            header.returns ={
                description: matches[1],
                types: matches[2].split(', ')
            };
            text = text.substr(matches[0].length);
            lineNumber++;
        } else {
            text = text.substr(matches[0].length);
        }
        lineNumber++;

        return header;
    }
}

module.exports = LayoutChecker;