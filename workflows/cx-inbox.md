---
description: Process inbox items — file, expand, connect, or discard captured notes one by one.
quick_summary: "Walk through inbox notes. For each: file, expand, connect, or discard."
requires_mcp: []
recommends_mcp: [sequential-thinking]
---

# /cx-inbox - Process Inbox

**Goal**: Work through unprocessed captures in the inbox, filing each to the right place in the vault.

> **Agent Reference**:
>
> - [librarian](../agents/librarian.md) — Filing, organizing, and connecting notes
>
> **Skill Reference**:
>
> - [pkm-methodology](../skills/pkm-methodology/SKILL.md) — Filing heuristics, note quality
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — Vault structure, wikilinks, tags

## When to Use

- You have accumulated captures in `00_Inbox` that need processing
- After a brainstorming session to sort and file ideas
- As a regular habit (daily or weekly inbox zero)

## Steps

1. **Read vault config** from `../config.md`:
   - Get the vault path and inbox folder name

2. **List inbox contents**:
   - Read all `.md` files in `{vault_path}/{inbox_folder}/`
   - Report count: "📥 **{N} notes** in inbox"
   - If inbox is empty: report "✅ Inbox is clear!" and exit

3. **Process each note** (one at a time):

   a. **Display the note**:
   - Show the filename and full content
   - Show any existing `#tags` and `[[wikilinks]]`

   b. **Analyze and suggest** (using the Librarian agent):
   - Suggest a **target folder** with reasoning (e.g., "This reads like a personal reflection → `10_Reflection`")
   - Suggest **related notes** from the vault that could be linked
   - Assess note quality (atomic? clear title? own words?)

   c. **Present actions**:
   - **📁 File** — Move to the suggested folder (or user-specified folder)
   - **✏️ Expand** — Flesh out the note through guided questions before filing
   - **🔗 Connect** — Add `[[wikilinks]]` to related notes, then file
   - **🗑️ Discard** — Delete the note (require confirmation)
   - **⏭️ Skip** — Leave in inbox for now, move to next note

   d. **Execute the chosen action**:
   - For **File**: Move the file to the target folder. If note quality is low, offer to upgrade the template from `fleeting` to `permanent`.
   - For **Expand**: Ask guided questions ("What made you think of this?", "How does this connect to what you're working on?", "Is there an action item here?"). Update the note content. Then proceed to File.
   - For **Connect**: Run a mini-version of `/cx-connect` on this note. Add approved `[[wikilinks]]`. Then proceed to File.
   - For **Discard**: Confirm with user. Delete the file.
   - For **Skip**: Move to the next note.

   e. **Confirm**: Report what was done (e.g., "📁 Filed `My thought.md` → `20_Ideas`")

4. **Summary**: After processing all notes (or user stops):
   - Report how many notes were filed, expanded, connected, discarded, skipped
   - Report remaining inbox count

## Usage

```bash
# Process all inbox notes
/cx-inbox

# Process with a specific focus
/cx-inbox "Just file everything quickly, no expansion"
```

## Key Principles

- **One at a time** — don't overwhelm with all notes at once
- **User always decides** — suggestions are suggestions, not decisions
- **Inbox zero is the goal** — but skipping is always an option
- **Quality is optional** — a filed note is better than a perfect note still in the inbox

## Next Steps

- `/cx-connect` — Deep-link a specific note after filing
- `/cx-review` — Review older notes for retention
- `/cx-capture` — Capture more thoughts
