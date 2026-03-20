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
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — Vault structure, wikilinks, tags, CLI commands

## When to Use

- You have accumulated captures in `00_Inbox` that need processing
- After a brainstorming session to sort and file ideas
- As a regular habit (daily or weekly inbox zero)

## CLI Commands Used

```bash
obsidian vault=Notepad files folder=00_Inbox           # List inbox contents
obsidian vault=Notepad read file="Note Title"          # Read a note's content
obsidian vault=Notepad file file="Note Title"          # Get file metadata
obsidian vault=Notepad move file="Note Title" to="20_Ideas"  # Move note to folder (auto-updates links)
obsidian vault=Notepad delete file="Note Title"        # Delete a note (sends to trash)
obsidian vault=Notepad append file="Note Title" content="..."  # Add content to a note
obsidian vault=Notepad backlinks file="Note Title"     # Check what links to this note
obsidian vault=Notepad links file="Note Title"         # Check outgoing links
obsidian vault=Notepad search query="..." format=json  # Find related notes
obsidian vault=Notepad tags file="Note Title"          # Get tags for a note
```

## Steps

1. **Read vault config** from `../config.md`

2. **List inbox contents** via CLI:

   ```bash
   obsidian vault=Notepad files folder=00_Inbox
   ```

   - Report count: "📥 **{N} notes** in inbox"
   - If inbox is empty: report "✅ Inbox is clear!" and exit

3. **Process each note** (one at a time):

   a. **Display the note** using CLI:

   ```bash
   obsidian vault=Notepad read file="Note Title"
   obsidian vault=Notepad tags file="Note Title"
   obsidian vault=Notepad links file="Note Title"
   ```

   - Show the filename, full content, tags, and existing links

   b. **Analyze and suggest** (using the Librarian agent):
   - Suggest a **target folder** with reasoning (e.g., "This reads like a personal reflection → `10_Reflection`")
   - Use `obsidian vault=Notepad search` to find **related notes** that could be linked
   - Assess note quality (atomic? clear title? own words?)

   c. **Present actions**:
   - **📁 File** — Move to the suggested folder (or user-specified folder)
   - **✏️ Expand** — Flesh out the note through guided questions before filing
   - **🔗 Connect** — Add `[[wikilinks]]` to related notes, then file
   - **🗑️ Discard** — Delete the note (require confirmation)
   - **⏭️ Skip** — Leave in inbox for now, move to next note

   d. **Execute the chosen action**:
   - For **File**: `obsidian vault=Notepad move file="Note Title" to="20_Ideas"` — auto-updates links. If note quality is low, offer to upgrade the template from `fleeting` to `permanent`.
   - For **Expand**: Ask guided questions ("What made you think of this?", "How does this connect to what you're working on?", "Is there an action item here?"). Use `obsidian vault=Notepad append` to update the note content. Then proceed to File.
   - For **Connect**: Run a mini-version of `/cx-connect` on this note. Use `obsidian vault=Notepad append` to add approved `[[wikilinks]]`. Then proceed to File.
   - For **Discard**: Confirm with user. `obsidian vault=Notepad delete file="Note Title"`.
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
