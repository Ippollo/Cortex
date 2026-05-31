---
description: Generate or update a Map of Content (MOC).
quick_summary: "Scan vault for topic → create structured MOC with grouped [[wikilinks]]."
requires_mcp: []
recommends_mcp: [sequential-thinking]
---

# /cx-map - Map of Content

**Goal**: Create or update a navigational Map of Content — a structured note that links to all notes on a topic, organized by subtopic.

> **Agent Reference**:
>
> - [synthesizer](../agents/synthesizer.md) — Topic analysis, grouping
>
> **Skill Reference**:
>
> - [pkm-methodology](../skills/pkm-methodology/SKILL.md) — MOC patterns
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — Wikilink format, file creation

## When to Use

- A topic has accumulated 5+ notes and is hard to navigate
- You want to create an entry point for a knowledge domain
- Before writing or presenting on a topic (build the map first)
- When onboarding future-you (or others) to a topic

## Path Resolution

All vault paths start with `c:\HQ\KB\`. Use `grep_search` to find notes by content or tags, `list_dir` to enumerate folders.

## Steps

1. **Identify the topic** from the user's input

2. **Scan the vault** for related notes using file-system tools:

   ```
   grep_search: Query="productivity", SearchPath="c:\HQ\KB\", MatchPerLine=true
   ```

   Also search by tag:

   ```
   grep_search: Query="tags:.*productivity", SearchPath="c:\HQ\KB\", IsRegex=true, MatchPerLine=true
   ```

   - Include notes from all folders (except `99_System`)
   - Use AI to assess relevance from search results

3. **Present findings**:

   ```
   🗺️ Map of Content: "Productivity"

   Found 8 related notes. Proposed grouping:

   ### Workflows
   - [[My Productivity Workflow]]
   - [[The Perfect Work Day]]

   ### Habits
   - [[Habit Formation]]
   - [[Building Routines]]

   ### Tools
   - [[Building Agentic apps]]
   - [[Obsidian as a Second Brain]]

   ### Reflections
   - [[Why Deep Work Matters]]
   - [[Context Switching is the Enemy]]

   Create this MOC?
   ```

4. **Create or update the MOC** via `write_to_file`:

   ```
   write_to_file: c:\HQ\KB\99_System\MOC - Productivity.md
   ```

   Content:
   ```markdown
   ---
   date: YYYY-MM-DD
   type: moc
   tags: [productivity]
   ---

   # MOC - Productivity

   {grouped_links}
   ```

   - Save to the user's chosen folder (suggest `99_System` or root)

5. **Handle existing MOCs**:
   - Check if a MOC for this topic exists: `grep_search` for `MOC - Productivity` in filenames
   - If it exists, read it with `view_file`, show what's new, and offer to merge
   - Update using read-modify-write with `write_to_file`

## Usage

```bash
# Create a MOC for a topic
/cx-map "productivity"

# Update an existing MOC
/cx-map "career"

# Create a MOC for a tag
/cx-map #architecture
```

## Key Principles

- **Navigability first** — a newcomer to the topic should orient themselves quickly
- **Group by subtopic** — don't just list links alphabetically
- **Brief descriptions** — one line per link explaining why it's included
- **Living document** — MOCs should be updated as new notes are added

## Next Steps

- `/cx-synthesize` — Create a synthesis note from the mapped notes
- `/cx-connect` — Add connections between individual notes
