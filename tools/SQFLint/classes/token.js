/*
    DO NOT USE WITHOUT EXCLUSIVE PERMISSION

    SQFLint
    Author: NetFusion
    https://github.com/netfusion/SQFLint

    Description:
    Token class for SQFLint
*/

class Token {
    constructor(type, lineNumber, columnNumber, value) {
        this.type = type;
        this.lineNumber = lineNumber;
        this.columnNumber = columnNumber;
        this.value = value;
    }
}

module.exports = Token;