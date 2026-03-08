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
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — File naming, tag format, vault path, CLI commands

## When to Use

- You have a thought or idea right now and want to save it
- You learned something and want to record it before you forget
- You want to bookmark a topic for later exploration
- Any time — this should be the lowest-friction action in the toolkit

## CLI Commands Used

```bash
obsidian create name="YYYY-MM-DD Title" content="..." template=fleeting open
obsidian files folder=00_Inbox          # Check for filename collisions
obsidian vault info=path                # Get vault path if needed
```

## Steps

// turbo-all

1. **Read vault config** from `../config.md`:
   - Get the vault path and inbox folder name

2. **Parse the user's input**:
   - Extract the content (everything the user typed after `/cx-capture`)
   - Extract any `#tags` from the content
   - Generate a title: use the first sentence or a slugified summary if no clear title
   - Generate a filename: `YYYY-MM-DD {title}.md`

3. **Create the note** via Obsidian CLI:

   ```bash
   obsidian create path="00_Inbox/YYYY-MM-DD {title}.md" content="{content}" template=fleeting
   ```

   - The CLI will error if the file already exists — if so, append a numeric suffix and retry
   - Falls back to `write_to_file` if Obsidian is not running

4. **Confirm**:
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
