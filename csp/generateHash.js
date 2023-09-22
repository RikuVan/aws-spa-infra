const fs = require('fs');
const crypto = require('crypto');
const dotenv = require('dotenv')
const path = require('path')

dotenv.config({ path: path.join(__dirname, '..', '.env') })

// Generate hash from JS file
const fileContent = fs.readFileSync('../app/js/app.js', 'utf-8')
const hash = crypto.createHash('sha256').update(fileContent).digest('base64')
const scriptHash = `sha256-${hash}`

console.log(`Generated hash: ${scriptHash}`)

let html = fs.readFileSync('../app/index_template.html', 'utf-8')

html = html.replace('{{CSP_HASH}}', scriptHash)

fs.writeFileSync('../app/index.html', html)

fs.readFile(path.join(__dirname, '..', '.env'), 'utf8', (err, data) => {
  if (err) {
    console.error('An error occurred:', err)
    return
  }

  const lines = data.split('\n')
  let found = false

  // Loop through each line to see if the CSP_HASH already exists
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].startsWith('export CSP_HASH=')) {
      lines[i] = `export CSP_HASH=${scriptHash}`
      found = true
      break
    }
  }

  // If CSP_HASH does not exist, add it
  if (!found) {
    lines.push(`export CSP_HASH=${scriptHash}`)
  }

  const updatedEnv = lines.join('\n')
  fs.writeFile(path.join(__dirname, '..', '.env'), updatedEnv, 'utf8', (err) => {
    if (err) {
      console.error('An error occurred:', err)
      return
    }

    console.log('.env file updated successfully')
  })
})

console.log('CloudFront function updated with CSP hash.');
