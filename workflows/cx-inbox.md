---
description: Process inbox items.
quick_summary: "Batch-read inbox notes, auto-file obvious cases, surface ambiguous ones for decision."
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

## Token Efficiency Rules

> **These rules exist to prevent excessive token usage. Follow them strictly.**

1. **Batch, don't loop** — Read all notes upfront, present one summary table, get batch approval. Do NOT process notes one-at-a-time with separate user confirmations unless the user explicitly requests it.
2. **Use `view_file` to read notes** — Returns clean, reliable content.
3. **Use PowerShell for frontmatter edits** — Do NOT use `replace_file_content` or `multi_replace_file_content` for markdown note housekeeping. Use a simple PowerShell string replacement:
   ```powershell
   (Get-Content "path/to/note.md" -Raw) -replace 'type: fleeting', "type: action`nstatus: todo" | Set-Content "path/to/note.md"
   ```
4. **Use PowerShell for move/delete** — `Move-Item` for filing, `Remove-Item` for discards. Since Obsidian resolves wikilinks by filename (not path), moving a file to a different folder does NOT require link updates.
5. **One search per note max** — Extract the most distinctive term from the title and run one `grep_search`. Don't run 2-3 overlapping searches per note.
6. **Skip reading config** — The vault config is in the system prompt via AGENTS.md. Don't re-read `../config.md` every session.

## Steps

1. **List inbox contents** via `list_dir`:

   ```
   list_dir: c:\HQ\KB\00_Inbox
   ```

   - Report count: "📥 **{N} notes** in inbox"
   - If inbox is empty: report "✅ Inbox is clear!" and exit

2. **Batch read all notes** using `view_file`:

   - Read every inbox note using `view_file` — issue all reads in parallel
   - For each note, extract: title, frontmatter (type, tags, status), content summary, any action signals

3. **Two-tier triage** — Classify each note:

   **Tier 1 — Auto-file (no AI judgment needed)**:
   - Notes with `type: task` already set → `10_Projects` (just add `status: todo` if missing, then move)
   - Notes with clear action verbs in title AND a "Done-When" or checklist section → `10_Projects`
   - Bare captures that are exact duplicates of existing notes (title match) → flag for discard
   - Notes with `tags: [decision]` → root vault (`decisions.md` append if applicable) or `10_Projects`
   - Notes with `tags: [meeting]` → `20_Journal`

   **Tier 2 — AI judgment needed**:
   - Notes with mixed signals (reference content + embedded actions)
   - Notes where the right folder isn't obvious
   - Notes that might be duplicates but need content comparison

4. **Present the batch summary** as a single table:

   ```
   | # | Note Title | Tier | Suggested Action | Destination |
   |---|-----------|------|-----------------|-------------|
   | 1 | Fix the bug | Auto | 📁 File (task) | 10_Projects |
   | 2 | Karpathy analysis | AI | 📁 File (action) | 10_Projects |
   | 3 | Old reminder | Auto | 🗑️ Discard | — |
   ```

   - For Tier 2 notes, include a brief rationale (1 sentence)
   - Flag any notes with embedded actions explicitly: "⚠️ Has action items"
   - Flag potential duplicates: "⚠️ Potential duplicate of [[existing note]]"

5. **Get batch approval** — Ask the user to:
   - Approve all suggestions, OR
   - Override specific rows (e.g., "Note 2 should go to 40_Knowledge instead")
   - Request expansion or connection for specific notes

6. **Execute all approved actions** in one pass:

   a. **Frontmatter updates** (all at once, using PowerShell):
   ```powershell
   # For action items needing type/status update:
   (Get-Content "c:\HQ\KB\00_Inbox\note.md" -Raw) -replace 'type: fleeting', "type: action`nstatus: todo" | Set-Content "c:\HQ\KB\00_Inbox\note.md"
   ```

   b. **Connection pass** (only for notes the user requested connections):
   - Run one `grep_search` per note for related content
   - Read the note, append `## Related` wikilinks, write back with `write_to_file`

   c. **Move pass** (all moves via PowerShell):
   ```powershell
   Move-Item "c:\HQ\KB\00_Inbox\Note Title.md" "c:\HQ\KB\10_Projects\Note Title.md"
   ```

   d. **Discard pass** (all discards, with confirmation):
   ```powershell
   Remove-Item "c:\HQ\KB\00_Inbox\Note Title.md"
   ```

7. **Summary**: Report what was done:
   - How many auto-filed, AI-filed, expanded, connected, discarded, skipped
   - Remaining inbox count

## Usage

```bash
# Standard batch processing
/cx-inbox

# Quick mode — auto-file everything, minimal interaction
/cx-inbox "Just file everything quickly"

# Thorough mode — connect every note before filing
/cx-inbox "Connect all notes before filing"
```

## Key Principles

- **Batch by default** — present all notes at once, minimize round-trips
- **User always decides** — suggestions are suggestions, not decisions
- **Inbox zero is the goal** — but skipping is always an option
- **Quality is optional** — a filed note is better than a perfect note still in the inbox
- **Cheap tools for cheap tasks** — PowerShell for text edits and moves, AI only for judgment calls

## Next Steps

- `/cx-connect` — Deep-link a specific note after filing
- `/cx-review` — Review older notes for retention
- `/cx-capture` — Capture more thoughts
