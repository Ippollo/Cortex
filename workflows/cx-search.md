---
description: Search the vault.
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

## Path Resolution

All vault paths start with `c:\HQ\KB\`. File-system tools require full paths. Use `grep_search` with the vault root as the search path.

## Steps

1. **Parse the query** from the user's input

2. **Search the vault** using file-system tools:

   a. **Full-text search** with line context:

   ```
   grep_search: Query="productivity", SearchPath="c:\HQ\KB\", MatchPerLine=true
   ```

   Returns file paths, line numbers, and matching content for all hits.

   b. **Tag match**:

   ```
   grep_search: Query="productivity", SearchPath="c:\HQ\KB\", Includes=["*.md"], MatchPerLine=true
   ```

   Filter results for `tags:` frontmatter lines to find notes tagged with the concept.

   c. **Semantic match**: Use AI to evaluate the search results and find notes related to the concept even without exact keyword overlap.

3. **Rank results** by relevance:
   - Exact title matches first
   - Tag matches second
   - Content matches third
   - Semantic matches last (but flagged as AI-suggested)

4. **Present results**:

   ```
   🔍 Search: "productivity"

   📌 Exact matches:
   1. My Productivity Workflow.md (20_Journal) — "A system for managing daily tasks..."
   2. Productivity Tools.md (40_Knowledge) — "Comparison of todo apps and..."

   🏷️ Tag matches:
   3. Habit Formation.md (30_Ideas) — #productivity #habits
   4. Deep Work Notes.md (40_Knowledge) — #productivity #focus

   🤖 AI-suggested:
   5. Building Agentic apps.md (00_Inbox) — discusses workflow optimization
   6. The Perfect Work Day.md (20_Journal) — time management framework

   View a note? (enter number)
   ```

5. **On selection**: Read and display the full note:
   ```
   view_file: c:\HQ\KB\{folder}\{filename}.md
   ```

## Usage

```bash
# Search by concept
/cx-search "productivity"

# Search by question
/cx-search "how I manage my time"

# Search for a specific note
/cx-search "Marco"
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
