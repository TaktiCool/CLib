const fs = require('fs');
const path = require('path');

const Lexer = require('./SQFLint/Lexer');
const Parser = require('./SQFLint/Parser');

const readFilesSync = (dir, filter) => {
    let files = [];

    fs.readdirSync(dir).forEach(file => {
        file = path.resolve(dir, file);
        const stat = fs.statSync(file);
        if (stat && stat.isDirectory()) {
            files = files.concat(readFilesSync(file, filter));
        } else {
            if (file.match(filter)) files.push(file);
        }
    });

    return files;
};

console.log('Validating SQF...');

// Allow running from root directory as well as from inside the tools directory
let rootDir = 'addons';
try {
    fs.accessSync('addons');
} catch (e) {
    rootDir = '../addons';
}

let errors = 0;
const files = readFilesSync(rootDir, /\.sqf$/);
files.forEach(file => {
    const content = fs.readFileSync(file, 'utf8');
    const tokens = Lexer.lex(content, file);
    if (tokens[tokens.length - 1].type == 'eos') {
        errors = errors + Parser.parse(tokens, file, content);
    } else {
        errors += 1;
    }
});

console.log('Validating finished with ' + errors + ' errors.');

return errors;