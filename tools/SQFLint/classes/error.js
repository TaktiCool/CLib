/*
    DO NOT USE WITHOUT EXCLUSIVE PERMISSION

    SQFLint
    Author: NetFusion
    https://github.com/netfusion/SQFLint

    Description:
    Error class for SQFLint
*/

const os = require('os');

class Error {
    constructor(message, filename, lineNumber, columnNumber, source) {
        let lines = source ? source.split('\n') : [];

        if (lineNumber >= 1 && lineNumber <= lines.length) {
            const startLine = Math.max(0, lineNumber - 3);
            const endLine = Math.min(lineNumber + 3, lines.length);

            lines = lines.slice(startLine, endLine);
            const context = lines.map((line, index) => {
                const currentLineNumber = index + startLine + 1;
                const preamble = (currentLineNumber == lineNumber ? '  > ' : '    ') + ("  " + currentLineNumber).substr(-3) + '| ';
                let output = preamble + line;
                if (currentLineNumber == lineNumber && columnNumber > 0) {
                    output += os.EOL;
                    output += '-'.repeat(preamble.length - 1 + columnNumber) + '^';
                }
                return output;
            }).join(os.EOL);

            message = filename + ':' + lineNumber + ':' + columnNumber + os.EOL + context + os.EOL + message + os.EOL;
        } else {
            message = filename + ':' + lineNumber + ':' + columnNumber + os.EOL + os.EOL + message + os.EOL;
        }

        console.error(message);
    }
}

module.exports = Error;