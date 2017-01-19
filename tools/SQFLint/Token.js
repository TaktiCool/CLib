/*
    DO NOT USE WITHOUT EXCLUSIVE PERMISSION

    Community Lib - CLib

    Author: NetFusion

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