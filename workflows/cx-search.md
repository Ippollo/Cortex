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
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — Vault path, file structure, CLI commands

## When to Use

- You know you wrote about something but can't find it
- You want to see everything related to a concept
- Before creating a new note, to check if one already exists
- When `/cx-connect` or `/cx-synthesize` need to discover related notes

## CLI Commands Used

```bash
obsidian vault=Notepad search query="..." format=json         # Keyword search across vault
obsidian vault=Notepad search:context query="..." format=json # Search with matching line context
obsidian vault=Notepad search query="..." path="folder"       # Search within a folder
obsidian vault=Notepad search query="..." total               # Get match count
obsidian vault=Notepad tag name="tagname" verbose              # Find notes with a specific tag
obsidian vault=Notepad tags counts sort=count                  # List all tags by frequency
obsidian vault=Notepad read file="Note Title"                  # Read a selected result
```

## Steps

1. **Read vault config** from `../config.md`

2. **Parse the query** from the user's input

3. **Search the vault** using CLI:

   a. **Full-text search** with context:

   ```bash
   obsidian vault=Notepad search:context query="productivity" format=json
   ```

   Returns grep-style `path:line: text` output for all matches.

   b. **Tag match**:

   ```bash
   obsidian vault=Notepad tag name="productivity" verbose
   ```

   Returns all files tagged with `#productivity`.

   c. **Semantic match**: Use AI to evaluate the search results and find notes related to the concept even without exact keyword overlap.

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

6. **On selection**: Read and display the full note:
   ```bash
   obsidian vault=Notepad read file="My Productivity Workflow"
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
