---
name: content-check
description: Final QA check that all edits from a reference doc were correctly applied to an email HTML template
allowed-tools: Read, Glob, Grep, Bash(find:*), Bash(pandoc:*)
---

Compare the edited email HTML template against the reference document used in this session to verify all content changes were applied correctly.

## 1. Identify the target email file

Check for an argument (e.g., `/content-check expedia/be/fr/policy-confirmation.html`). If provided, use that path.

If no argument is given, identify the file from context:
- Check which file the user was working on in this conversation
- If unclear, find the most recently modified HTML file under the working directory:
  ```bash
  find . -name "*.html" -not -path "*/node_modules/*" -not -path "*/_template/*" -newer .git/index | head -10
  ```
- Confirm the target file with the user if ambiguous.

Read the full HTML file.

## 2. Identify the reference document

Look back through the current conversation for the reference content the user provided. This could be:
- A block of pasted text (translated copy, content brief, redline document)
- A file path the user mentioned
- A previous message where the user said "use this as the reference" or "update based on this"

If a file path was given, read that file now. If it is a `.docx`, extract it with `pandoc "<file>" -t markdown` — never `cat`, `unzip + grep`, or `textutil` (pandoc is the only tool that preserves links, bold/italic, and lists faithfully).

If the reference was pasted inline in the conversation, extract it from the conversation context.

If you cannot locate a reference document, ask the user to paste or point to it before continuing.

## 3. Build an inventory of expected changes

From the reference document, extract every discrete content change that was requested:

For each item, record:
- **Type:** text update / link update / phone number / email address / section added / section removed / variable replacement / other
- **Location:** where in the email it should appear (section name, heading, paragraph)
- **Expected value:** exactly what the reference says it should be

Number each item so the report is easy to scan (e.g. [1], [2], [3]…).

## 4. Check each expected change against the HTML

For each item in the inventory, search the HTML to verify:

- **Applied correctly** — the value from the reference is present in the right location
- **Applied with deviation** — something was changed but differs from the reference (wrong wording, different formatting, truncated text, etc.)
- **Missing** — the change was not made at all

When comparing text, account for:
- HTML entity encoding (e.g. `&amp;`, `&eacute;`)
- Whitespace and line breaks inside tags
- Handlebars variables `{{...}}` that should be preserved — do not flag these as missing content
- Inline styles or tags wrapping the text (`<strong>`, `<a href>`, etc.)

## 5. Check for unintended changes

Beyond the expected edits, scan the HTML for any content that looks like it was modified but wasn't in the reference document:
- Text that differs from what a standard template would contain
- Handlebars variables that were altered or removed
- Links or phone numbers that changed without being in the reference
- Structural changes (added/removed rows, columns, sections)

Flag anything suspicious as **Unintended change — verify**.

## 6. Report results

Output a structured report with three sections:

---

### ✅ Applied correctly
List each item that matches the reference exactly, with a brief description.

### ⚠️ Applied with deviation
For each: what the reference said, what the HTML contains, and the specific difference.

### ❌ Missing
List any expected changes not found in the HTML, with the exact value that should be there.

### 🔍 Unintended changes (verify)
List anything that changed beyond the reference scope, or flag "None detected" if clean.

---

End with a one-line summary: total items checked, how many passed, how many need attention.

If everything looks correct, confirm clearly: **All reference changes verified — template is good to ship.**
