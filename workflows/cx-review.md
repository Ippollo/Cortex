---
description: Surface older notes for review using spaced repetition and connection-based prioritization.
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

## Steps

1. **Read vault config** from `../config.md`

2. **Scan the vault** (excluding `00_Inbox` and `99_System`):
   - Read file modification dates
   - Count `[[wikilinks]]` (both incoming and outgoing) for each note
   - Identify `#tags` per note

3. **Score and rank notes** for review priority:
   - **Recency weight**: Notes not modified in 30+ days rank higher
   - **Connection weight**: Notes with more links are higher value (they connect ideas)
   - **Novelty weight**: Notes never reviewed before rank higher
   - **Exclude**: Notes modified in the last 7 days (too fresh)

4. **Surface 3-5 notes**:

   ```
   📖 Review session — 4 notes to revisit:

   1. "The Value of Constraints" (20_Ideas) — last modified 45 days ago, 3 links
   2. "Conversation with Marco" (30_People) — last modified 60 days ago, 0 links
   3. "Event Sourcing for Audit Trails" (40_Reference) — last modified 30 days ago, 1 link
   4. "Why I Build in Public" (10_Reflection) — last modified 90 days ago, 2 links

   Start with #1?
   ```

5. **For each note**, show the content and offer actions:
   - **✏️ Update** — Edit the note (add context, refine wording, distill further)
   - **🔗 Connect** — Run `/cx-connect` on this note to add links
   - **✅ Mark reviewed** — Touch the file's modification date to reset the review clock
   - **⏭️ Skip** — Move to the next note

6. **Summary** after the session:
   - How many notes reviewed, updated, connected
   - Suggest scheduling the next review

## Usage

```bash
# Standard review session (3-5 notes)
/review

# Review notes from a specific folder
/review --folder "20_Ideas"

# Review notes with a specific tag
/review #productivity
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
