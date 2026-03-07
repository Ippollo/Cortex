---
description: Generate or update a Map of Content (MOC) for a topic with organized wikilinks.
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

## Steps

1. **Identify the topic** from the user's input

2. **Scan the vault** for related notes:
   - Search by title keywords, `#tags`, and content similarity
   - Include notes from all folders (except `99_System`)

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

4. **Create or update the MOC**:
   - Use the `moc.md` template
   - Save to the user's chosen folder (suggest `40_Reference` or root)
   - Filename: `MOC - {topic}.md`

5. **Handle existing MOCs**:
   - If a MOC for this topic exists, show what's new and offer to merge
   - Add new notes, preserve existing groupings and user customizations

## Usage

```bash
# Create a MOC for a topic
/map "productivity"

# Update an existing MOC
/map "career"

# Create a MOC for a tag
/map #architecture
```

## Key Principles

- **Navigability first** — a newcomer to the topic should orient themselves quickly
- **Group by subtopic** — don't just list links alphabetically
- **Brief descriptions** — one line per link explaining why it's included
- **Living document** — MOCs should be updated as new notes are added

## Next Steps

- `/cx-synthesize` — Create a synthesis note from the mapped notes
- `/cx-connect` — Add connections between individual notes
