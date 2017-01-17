const fs = require('fs');

console.log('Validating SQF');

// Allow running from root directory as well as from inside the tools directory
fs.exists('addons', (exists) => {
    let rootDir = exists ? 'addons' : '../addons';

    fs.readdir(rootDir, (err, files) => {
        if (err) {
            console.error(err);
            return;
        }

        console.log(files);
    });
});
