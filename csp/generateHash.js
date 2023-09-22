const fs = require('fs');
const crypto = require('crypto');

// Generate hash from JS file
const fileContent = fs.readFileSync('../app/js/app.js', 'utf-8');
const hash = crypto
    .createHash('sha256')
    .update(fileContent)
    .digest('base64');
const scriptHash = `sha256-${hash}`;

console.log(`Generated hash: ${scriptHash}`);

let cloudFrontFunction = fs.readFileSync('./functionCsp.js', 'utf-8');

cloudFrontFunction = cloudFrontFunction.replace('{{CSP_HASH}}', scriptHash);

fs.writeFileSync('../modules/spa/functionToAddHeaders.js', cloudFrontFunction);

console.log('CloudFront function updated with CSP hash.');
