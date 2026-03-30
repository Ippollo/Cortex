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
obsidian vault=KB files folder=00_Inbox           # List inbox contents
obsidian vault=KB read file="Note Title"          # Read a note's content
obsidian vault=KB file file="Note Title"          # Get file metadata
obsidian vault=KB move file="Note Title" to="20_Ideas"  # Move note to folder (auto-updates links)
obsidian vault=KB delete file="Note Title"        # Delete a note (sends to trash)
obsidian vault=KB append file="Note Title" content="..."  # Add content to a note
obsidian vault=KB backlinks file="Note Title"     # Check what links to this note
obsidian vault=KB links file="Note Title"         # Check outgoing links
obsidian vault=KB search query="..." format=json  # Find related notes
obsidian vault=KB tags file="Note Title"          # Get tags for a note
```

## Steps

1. **Read vault config** from `../config.md`

2. **List inbox contents** via CLI:

   ```bash
   obsidian vault=KB files folder=00_Inbox
   ```

   - Report count: "📥 **{N} notes** in inbox"
   - If inbox is empty: report "✅ Inbox is clear!" and exit

3. **Process each note** (one at a time):

   a. **Display the note** using CLI:

   ```bash
   obsidian vault=KB read file="Note Title"
   obsidian vault=KB tags file="Note Title"
   obsidian vault=KB links file="Note Title"
   ```

   - Show the filename, full content, tags, and existing links

   b. **Analyze and suggest** (using the Librarian agent):

   - **Check for duplicates first**: Before any filing suggestion, search the vault for existing notes that cover the same topic:
     - Extract 2-3 key terms from the note's title and content
     - Run `obsidian vault=KB search query="..." format=json` for each term
     - Read any promising matches to compare content
     - If an existing note covers the same ground → flag as **⚠️ Potential duplicate** and suggest **🗑️ Discard** or **🔀 Merge** (append unique content into the existing note, then discard)
     - Bare captures without frontmatter are the most likely duplicates — be extra thorough with these

   - **Check for actionability**: Does this note describe something the user needs to *do*? Look for signals:
     - Action verbs ("research", "build", "fix", "update", "set up")
     - Tags like `action-item`
     - Phrases like "I should", "I need to", "to-do"
   - If actionable → suggest `10_Projects` and offer to convert frontmatter to `type: action` with `status: todo`
   - If not actionable → suggest a target folder with reasoning (e.g., "This reads like a personal reflection → `20_Journal`")
   - Use `obsidian vault=KB search` to find **related notes** that could be linked
   - Assess note quality (atomic? clear title? own words?)

   c. **Present actions**:
   - **📁 File** — Move to the suggested folder (or user-specified folder)
   - **✏️ Expand** — Flesh out the note through guided questions before filing
   - **🔗 Connect** — Add `[[wikilinks]]` to related notes, then file
   - **🔀 Merge** — Append unique content into an existing note, then discard this one (shown when duplicate detected)
   - **🗑️ Discard** — Delete the note (require confirmation)
   - **⏭️ Skip** — Leave in inbox for now, move to next note

   d. **Execute the chosen action**:
   - For **File to `10_Projects`**: Update frontmatter (`type: action`, add `status: todo`, optionally add `priority`, `project`, `section`, `due`), then move: `obsidian vault=KB move file="Note Title" to="10_Projects"`.
   - For **File** (non-action): `obsidian vault=KB move file="Note Title" to="30_Ideas"` — auto-updates links. If note quality is low, offer to upgrade the template from `fleeting` to `permanent`.
   - For **Expand**: Ask guided questions ("What made you think of this?", "How does this connect to what you're working on?", "Is there an action item here?"). Use `obsidian vault=KB append` to update the note content. Then proceed to File.
   - For **Connect**: Run a mini-version of `/cx-connect` on this note. Use `obsidian vault=KB append` to add approved `[[wikilinks]]`. Then proceed to File.
   - For **Merge**: Show the target note and what will be appended. Use `obsidian vault=KB append file="Target Note" content="..."` to add unique content. Then `obsidian vault=KB delete file="Note Title"` to remove the duplicate.
   - For **Discard**: Confirm with user. `obsidian vault=KB delete file="Note Title"`.
   - For **Skip**: Move to the next note.

   e. **Confirm**: Report what was done (e.g., "📁 Filed `My thought.md` → `30_Ideas`" or "✅ Task `Fix the bug.md` → `10_Projects` [status: todo]")

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
