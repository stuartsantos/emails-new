const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

const RESPONSE_DIR = path.join(__dirname, '../response');
const OUTPUT_FILE = path.join(__dirname, '../build/email.html');
const DEBOUNCE_MS = 500;

let lastProcessed = 0;

function extractAndOpen(jsonPath) {
  const now = Date.now();
  if (now - lastProcessed < DEBOUNCE_MS) return;
  lastProcessed = now;
  try {
    const data = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
    if (data.body) {
      fs.writeFileSync(OUTPUT_FILE, data.body);
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
