---
description: Surface older notes for review.
quick_summary: "Surface 3-5 forgotten notes → review, update, connect, or mark as reviewed."
requires_mcp: []
recommends_mcp: []
---

# /cx-review - Review for Retention

**Goal**: Surface notes you haven't seen in a while, prioritizing high-value and well-connected notes. Progressive summarization through repeated encounters.

> **Skill Reference**:
>
> - [pkm-methodology](../skills/pkm-methodology/SKILL.md) — Progressive summarization, review heuristics

## When to Use

- As a regular habit (weekly or bi-weekly)
- When you feel disconnected from your knowledge base
- When you want to rediscover ideas you've forgotten
- After a period of heavy capture, to integrate new notes with old

## Path Resolution

All vault paths start with `c:\HQ\KB\`. Use `list_dir` to enumerate folders and `view_file` to read notes.

## Steps

1. **Scan the vault** via file-system tools (excluding `00_Inbox` and `99_System`):

   Use `list_dir` on each target folder to enumerate notes:

   ```
   list_dir: c:\HQ\KB\10_Projects
   list_dir: c:\HQ\KB\20_Journal
   list_dir: c:\HQ\KB\30_Ideas
   list_dir: c:\HQ\KB\40_Knowledge
   ```

   For each note, use PowerShell to get file metadata (modified date, size):

   ```powershell
   Get-ChildItem "c:\HQ\KB\30_Ideas\*.md" | Select-Object Name, LastWriteTime, Length | Sort-Object LastWriteTime
   ```

2. **Check for orphans** (notes with no incoming links — partial fidelity):

   For candidate notes, `grep_search` for `[[Note Title]]` across the vault. Notes with zero hits are likely orphans.

   > **Trade-off**: This misses aliased links (`[[Note|Display]]`) and can't replicate Obsidian's full link graph. Acceptable for review prioritization — orphan detection is a heuristic, not a guarantee.

3. **Score and rank notes** for review priority:
   - **Recency weight**: Notes not modified in 30+ days rank higher
   - **Connection weight**: Notes referenced by other notes are higher value
   - **Novelty weight**: Notes never reviewed before rank higher
   - **Orphan bonus**: Unlinked notes are prioritized for connection
   - **Exclude**: Notes modified in the last 7 days (too fresh)

4. **Surface 3-5 notes**:

   ```
   📖 Review session — 4 notes to revisit:

   1. "The Value of Constraints" (30_Ideas) — last modified 45 days ago, 3 links
   2. "Conversation with Marco" (20_Journal) — last modified 60 days ago, 0 links ⚠️ orphan
   3. "Event Sourcing for Audit Trails" (40_Knowledge) — last modified 30 days ago, 1 link
   4. "Why I Build in Public" (20_Journal) — last modified 90 days ago, 2 links

   Start with #1?
   ```

5. **For each note**, read via `view_file` and offer actions:
   - **✏️ Update** — Edit the note (add context, refine wording, distill further) via read-modify-write with `write_to_file`
   - **🔗 Connect** — Run `/cx-connect` on this note to add links
   - **✅ Mark reviewed** — Touch the file to reset the review clock (PowerShell: `(Get-Item "path").LastWriteTime = Get-Date`)
   - **⏭️ Skip** — Move to the next note

6. **Summary** after the session:
   - How many notes reviewed, updated, connected
   - Suggest scheduling the next review

## Usage

```bash
# Standard review session (3-5 notes)
/cx-review

# Review notes from a specific folder
/cx-review --folder "30_Ideas"

# Review notes with a specific tag
/cx-review #productivity
```

## Key Principles

- **Short sessions** — review 3-5 notes, not the whole vault
- **Progressive summarization** — each review is a chance to distill the note further
- **Connections are the real value** — unlinked notes are isolated knowledge
- **No guilt** — skipping is fine; not everything needs revisiting

## Next Steps

- `/cx-connect` — Deep-link a reviewed note
- `/cx-synthesize` — Combine reviewed notes into insights
- `/cx-inbox` — Process new captures
