---
name: ship
description: Analyze changes, generate commit message, update docs if needed, and push to main
allowed-tools: Bash(git:*), Read, Edit, Write
---

Automate the full commit-and-push workflow for this email templates repo. Follow every step below in order.

## 1. Pre-flight

Run these commands to understand the current state:

```bash
git status
git diff
git diff --cached
git log --oneline -5
git diff --stat
```

If the working tree is completely clean (no staged, unstaged, or untracked changes), stop and tell the user there is nothing to ship.

## 2. Safety checks

Before staging, scan for files that must NEVER be committed:

- `.env`, `.env.*`
- `credentials*`, `*secret*`, `*token*`
- `node_modules/`
- `.DS_Store`
- `*.log`

If any of these appear in the changeset, exclude them from staging and warn the user.

## 3. Stage changes

Add files using specific paths or directory-scoped commands like `git add <dir>/`. Stage related changes together by brand/directory.

**Never use `git add -A` or `git add .`** — always name files or directories explicitly.

## 4. Generate commit message

Analyze the staged diff and write a commit message following this project's style:

- **Subject line:** imperative mood, under 72 characters, references brand/market when applicable (e.g., "Add Expedia CA French policy confirmation template")
- **Body:** organized by brand/market with specific bullet points describing what changed and why

Use a heredoc to pass the message:

```bash
git commit -m "$(cat <<'EOF'
Subject line here

- bullet point details
- organized by brand/market
EOF
)"
```

## 5. Check CLAUDE.md docs

Read the relevant CLAUDE.md files and determine if any need updating based on the changes being shipped. Only update when genuinely warranted — do not force unnecessary doc changes.

| File | Update when... |
|------|----------------|
| `CLAUDE.md` (root) | New shared patterns, repo structure changes |
| `expedia/CLAUDE.md` | New markets, templates, or status changes |
| `row/CLAUDE.md` | New countries, rebranding progress, status changes |
| `qantas/claude.md` | Template status updates |
| `tg/us/zurich/claude.md` | New emails, images, completed follow-ups |

If updates are needed:
1. Make the edits
2. Stage the updated doc files by name
3. Amend the commit to include them, or note them in the commit body

If no doc updates are needed, skip this step entirely.

## 6. Pull and push

Rebase on remote before pushing:

```bash
git pull origin main --rebase
git push origin main
```

If the rebase hits conflicts:
1. Run `git rebase --abort`
2. Tell the user to resolve conflicts manually
3. Stop — do not force push

## 7. Clean up merged branches

Delete any local branches that have already been merged into main:

```bash
git branch --merged main --format='%(refname:short)' | grep -v '^main$' | xargs git branch -d 2>/dev/null
```

If any branches were deleted, note them in the summary. If none were found, skip silently.

## 8. Summary

Report back with:
- Commit hash (short)
- Number of files changed
- Which docs were updated (if any)
- Branches cleaned up (if any)
- Push confirmation or error details
