const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

const RESPONSE_DIR = path.join(__dirname, '../response');
const OUTPUT_FILE = path.join(__dirname, '../build/email.html');
const DEBOUNCE_MS = 500;

let lastProcessed = 0;

function extractBody(raw) {
  // Try standard JSON.parse first (works with Thunder Client responses)
  try {
    return JSON.parse(raw).body;
  } catch (_) {}
  // Fallback: extract body field directly (handles Postman responses
  // where embedded JS escape sequences like \x22 make the JSON invalid)
  const start = raw.indexOf('"body": "');
  if (start === -1) return null;
  const bodyStart = start + 9;
  const bodyEnd = raw.lastIndexOf('",');
  if (bodyEnd <= bodyStart) return null;
  return raw.substring(bodyStart, bodyEnd).replace(/\\"/g, '"');
}

function extractAndOpen(jsonPath) {
  const now = Date.now();
  if (now - lastProcessed < DEBOUNCE_MS) return;
  lastProcessed = now;
  try {
    const raw = fs.readFileSync(jsonPath, 'utf8');
    const body = extractBody(raw);
    if (body) {
      fs.writeFileSync(OUTPUT_FILE, body);
      console.log(`✓ Extracted HTML to ${OUTPUT_FILE}`);

      // Auto-open in browser (cross-platform)
      const cmd = process.platform === 'darwin' ? 'open'
                : process.platform === 'win32' ? 'start' : 'xdg-open';
      exec(`${cmd} "${OUTPUT_FILE}"`);
    }
  } catch (err) {
    console.error('Error:', err.message);
  }
}

console.log(`Watching ${RESPONSE_DIR} for changes...`);
fs.watch(RESPONSE_DIR, (event, filename) => {
  if (filename?.endsWith('.json')) {
    extractAndOpen(path.join(RESPONSE_DIR, filename));
  }
});
