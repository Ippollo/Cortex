---
description: Create a daily note.
quick_summary: "Create today's dated note with prompts and recent capture links."
requires_mcp: []
recommends_mcp: []
---

# /cx-daily - Daily Note

**Goal**: Create a daily note for today with reflection prompts and links to recent activity in the vault.

> **Skill Reference**:
>
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — File naming, vault path, CLI commands

## When to Use

- Start of day to set intentions
- End of day to reflect
- Any time to create a dated journal entry

## CLI Commands Used

```bash
obsidian vault=KB daily                           # Open/create today's daily note
obsidian vault=KB daily:path                      # Get expected daily note path
obsidian vault=KB daily:read                      # Read daily note contents
obsidian vault=KB daily:append content="..."      # Append content to daily note
obsidian vault=KB daily:prepend content="..."     # Prepend content to daily note
obsidian vault=KB recents                         # List recently opened files
obsidian vault=KB files folder=00_Inbox           # Check inbox for recent captures
```

## Steps

// turbo-all

1. **Read vault config** from `../config.md`

2. **Check if daily note exists** via CLI:

   ```bash
   obsidian vault=KB daily:path     # Get the expected path
   obsidian vault=KB daily:read     # Try to read — if it exists, show it
   ```

   - If it exists: display the existing note content and offer to append
   - If not: proceed to create

3. **Scan for recent activity** using CLI:

   ```bash
   obsidian vault=KB recents                    # Recently opened files
   obsidian vault=KB files folder=00_Inbox     # Current inbox items
   ```

4. **Create the daily note** via CLI:

   ```bash
   obsidian vault=KB daily   # Creates and opens the daily note using Obsidian's daily note settings
   ```

   - If the template needs custom content (recent links, prompts), use:

   ```bash
   obsidian vault=KB daily:append content="## Recent Captures\n- [[Note 1]]\n- [[Note 2]]"
   ```

   - Falls back to manual file creation using the `daily.md` template if Obsidian is not running

5. **Report**: `📅 Daily note created → {daily_folder}/YYYY-MM-DD.md`

## Usage

```bash
# Create today's daily note
/cx-daily

# Create a daily note for a specific date
/cx-daily 2026-03-05
```

## Key Principles

- **Consistency** — same format every day, easy to build a habit
- **Links to recent work** — connect the day to your knowledge activity
- **Prompts, not pressure** — the template suggests, the user fills in what matters

## Next Steps

- `/cx-capture` — Capture ideas that come up during daily reflection
- `/cx-inbox` — Process any inbox items linked from the daily note
- `/cx-review` — Combine daily reflection with a note review session
