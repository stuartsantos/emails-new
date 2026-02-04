# API Testing - Email HTML Extractor

## Overview
This setup extracts email HTML from Thunder Client API responses and auto-opens them in the browser for preview.

## Directory Structure
```
api-testing/
├── build/
│   └── email.html      # Extracted HTML output
├── response/
│   └── response.json   # Save Thunder Client responses here
├── script/
│   └── watch-response.js  # File watcher script (requires Node.js)
└── extract.html        # Browser-based extractor (no Node.js needed)
```

## Usage

### Start the watcher
```bash
cd api-testing
npm run watch
```

Or with Claude Code:
```
/watch-email
```

### Workflow
1. Start the watcher
2. Make an API call in Thunder Client
3. Save the response JSON to `api-testing/response/`
4. The watcher extracts the `body` field and writes it to `api-testing/build/email.html`
5. The email automatically opens in your default browser

## Manual Workaround (No Node.js)

For computers without Node.js installed, use the browser-based extractor:

1. Open `api-testing/extract.html` in your browser
2. Make an API call in Thunder Client
3. Copy the **entire JSON response** (not just the body)
4. Paste into the text area and click "Extract & Preview"
5. The email opens in a new tab (use "Copy HTML" to save it)

## How it works
- The watcher uses `fs.watch()` to monitor the `response/` directory for `.json` file changes
- When a change is detected, it parses the JSON and extracts the `body` field
- The HTML is written to `build/email.html` and opened in the browser
- Debouncing (500ms) prevents duplicate triggers from `fs.watch` events
