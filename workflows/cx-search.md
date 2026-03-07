---
description: Search the vault for notes matching a query using keyword and semantic matching.
quick_summary: "Search vault by keyword + AI semantic matching → display results with previews."
requires_mcp: []
recommends_mcp: []
---

# /cx-search - Vault Search

**Goal**: Find notes in the vault matching a query, using both keyword matching and AI-powered semantic search.

> **Skill Reference**:
>
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — Vault path, file structure

## When to Use

- You know you wrote about something but can't find it
- You want to see everything related to a concept
- Before creating a new note, to check if one already exists
- When `/cx-connect` or `/cx-synthesize` need to discover related notes

## Steps

1. **Read vault config** from `../config.md`

2. **Parse the query** from the user's input

3. **Search the vault** using multiple strategies:

   a. **Filename match**: Search note titles for the query terms
   b. **Tag match**: Search for `#tags` matching the query
   c. **Content match**: Grep note content for the query terms
   d. **Semantic match**: Use AI to find notes related to the concept even without exact keywords

4. **Rank results** by relevance:
   - Exact title matches first
   - Tag matches second
   - Content matches third
   - Semantic matches last (but flagged as AI-suggested)

5. **Present results**:

   ```
   🔍 Search: "productivity"

   📌 Exact matches:
   1. My Productivity Workflow.md (10_Reflection) — "A system for managing daily tasks..."
   2. Productivity Tools.md (40_Reference) — "Comparison of todo apps and..."

   🏷️ Tag matches:
   3. Habit Formation.md (20_Ideas) — #productivity #habits
   4. Deep Work Notes.md (40_Reference) — #productivity #focus

   🤖 AI-suggested:
   5. Building Agentic apps.md (00_Inbox) — discusses workflow optimization
   6. The Perfect Work Day.md (10_Reflection) — time management framework

   View a note? (enter number)
   ```

6. **On selection**: Display the full note content inline

## Usage

```bash
# Search by concept
/search "productivity"

# Search by question
/search "how I manage my time"

# Search for a specific note
/search "Marco"
```

## Key Principles

- **Fast first, smart second** — show keyword matches immediately, then AI results
- **Preview, don't overwhelm** — show first sentence, not full content
- **Deduplication** — if a note matches multiple strategies, show it once with the highest-rank match type
- **Zero results is useful** — "No notes found" means it's safe to create a new one

## Next Steps

- `/cx-capture` — Create a new note if the search comes up empty
- `/cx-connect` — Connect a found note to other notes
- `/cx-synthesize` — Synthesize notes from search results
