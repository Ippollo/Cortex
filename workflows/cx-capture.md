---
description: Instant note capture to Obsidian inbox from Antigravity. No context switch, no friction.
quick_summary: "Capture a thought → timestamped markdown in vault inbox. Zero friction."
requires_mcp: []
recommends_mcp: []
---

# /cx-capture - Quick Capture

**Goal**: Capture a thought, idea, or learning instantly into the Obsidian vault without leaving Antigravity.

> **Skill Reference**:
>
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — File naming, tag format, vault path

## When to Use

- You have a thought or idea right now and want to save it
- You learned something and want to record it before you forget
- You want to bookmark a topic for later exploration
- Any time — this should be the lowest-friction action in the toolkit

## Steps

// turbo-all

1. **Read vault config** from `../config.md`:
   - Get the vault path
   - Get the inbox folder name

2. **Parse the user's input**:
   - Extract the content (everything the user typed after `/cx-capture`)
   - Extract any `#tags` from the content
   - Generate a title: use the first sentence or a slugified summary if no clear title
   - Generate a filename: `YYYY-MM-DD {title}.md`

3. **Check for filename collision**:
   - If a file with that name already exists in the inbox folder, append a numeric suffix: `YYYY-MM-DD {title} 2.md`

4. **Create the note**:
   - Use the `fleeting.md` template
   - Replace `{title}` with the generated title
   - Replace `{content}` with the user's full input
   - Replace `{tags}` with any extracted tags (or remove the line if none)

5. **Write the file** to `{vault_path}/{inbox_folder}/{filename}`

6. **Confirm**:
   - Report: `✅ Captured → {inbox_folder}/{filename}`
   - Suggest: "Run `/cx-inbox` later to process and file this note."

## Usage

```bash
# Quick thought
/cx-capture I should explore using Zettelkasten for my knowledge management

# With tags
/cx-capture The key to habit formation is making the behavior easy, not motivating #productivity #habits

# Longer capture
/cx-capture "Met with Sarah today. She mentioned that their team uses event sourcing for audit trails. Worth exploring for the Job Hunter activity log. #architecture #job-hunter"
```

## Key Principles

- **Speed over perfection** — the note doesn't need to be clean, just captured
- **No questions asked** — don't prompt the user for tags, folders, or metadata unless they explicitly asked for help
- **Inbox is temporary** — everything captured here will be processed by `/cx-inbox` later

## Next Steps

- `/cx-inbox` — Process captured notes (file, expand, connect, or discard)
- `/cx-connect` — Find related notes for a specific capture
