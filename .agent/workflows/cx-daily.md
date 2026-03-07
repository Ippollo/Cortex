---
description: Create a daily note with reflection prompts and links to recent captures.
quick_summary: "Create today's dated note with prompts and recent capture links."
requires_mcp: []
recommends_mcp: []
---

# /cx-daily - Daily Note

**Goal**: Create a daily note for today with reflection prompts and links to recent activity in the vault.

> **Skill Reference**:
>
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — File naming, vault path

## When to Use

- Start of day to set intentions
- End of day to reflect
- Any time to create a dated journal entry

## Steps

// turbo-all

1. **Read vault config** from `../config.md`:
   - Get the vault path and daily notes folder

2. **Generate filename**: `YYYY-MM-DD.md` using today's date

3. **Check if daily note exists**:
   - If it exists: display the existing note content and offer to append
   - If not: create a new one

4. **Scan for recent activity**:
   - Find notes created or modified in the last 24 hours
   - Find notes currently in the inbox

5. **Create the note** using the `daily.md` template:
   - Replace `{date}` with today's date (formatted: `March 6, 2026`)
   - Replace `{recent_inbox_items}` with `[[wikilinks]]` to recent captures
   - Leave `{reflection}` and `{focus_items}` as prompts for the user to fill in

6. **Write the file** to `{vault_path}/{daily_folder}/{filename}`

7. **Report**: `📅 Daily note created → {daily_folder}/YYYY-MM-DD.md`

## Usage

```bash
# Create today's daily note
/daily

# Create a daily note for a specific date
/daily 2026-03-05
```

## Key Principles

- **Consistency** — same format every day, easy to build a habit
- **Links to recent work** — connect the day to your knowledge activity
- **Prompts, not pressure** — the template suggests, the user fills in what matters

## Next Steps

- `/cx-capture` — Capture ideas that come up during daily reflection
- `/cx-inbox` — Process any inbox items linked from the daily note
- `/cx-review` — Combine daily reflection with a note review session
