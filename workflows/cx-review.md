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

## CLI Commands Used

```bash
obsidian vault=KB files folder="30_Ideas"                # List files in a folder
obsidian vault=KB file file="Note Title"                 # Get metadata (created, modified, size)
obsidian vault=KB backlinks file="Note Title" total      # Count incoming links
obsidian vault=KB links file="Note Title" total          # Count outgoing links
obsidian vault=KB orphans                                # Notes with zero incoming links
obsidian vault=KB deadends                               # Notes with zero outgoing links
obsidian vault=KB read file="Note Title"                 # Read note content
obsidian vault=KB tags file="Note Title"                 # Get note tags
obsidian vault=KB append file="Note Title" content="..." # Add review notes
```

## Steps

1. **Read vault config** from `../config.md`

2. **Scan the vault** via CLI (excluding `00_Inbox` and `99_System`):

   ```bash
   obsidian vault=KB files ext=md                    # List all markdown files
   obsidian vault=KB file file="Note Title"          # Get modified date per note
   obsidian vault=KB backlinks file="Note Title" total  # Get link count per note
   ```

   - Also check for orphans and dead-ends as priority candidates:

   ```bash
   obsidian vault=KB orphans    # High-priority: unlinked, forgotten notes
   obsidian vault=KB deadends   # Notes that don't link out — potential to connect
   ```

3. **Score and rank notes** for review priority:
   - **Recency weight**: Notes not modified in 30+ days rank higher
   - **Connection weight**: Notes with more links are higher value (they connect ideas)
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

5. **For each note**, read via `obsidian read` and offer actions:
   - **✏️ Update** — Edit the note (add context, refine wording, distill further) via `obsidian append`
   - **🔗 Connect** — Run `/cx-connect` on this note to add links
   - **✅ Mark reviewed** — Touch the file to reset the review clock
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
