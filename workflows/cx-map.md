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
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — Wikilink format, file creation, CLI commands

## When to Use

- A topic has accumulated 5+ notes and is hard to navigate
- You want to create an entry point for a knowledge domain
- Before writing or presenting on a topic (build the map first)
- When onboarding future-you (or others) to a topic

## CLI Commands Used

```bash
obsidian vault=KB search query="..." format=json          # Find notes related to topic
obsidian vault=KB tag name="tagname" verbose               # Find notes sharing a tag
obsidian vault=KB tags counts sort=count format=json       # Discover tag vocabulary
obsidian vault=KB read file="Note Title"                   # Read candidate notes
obsidian vault=KB backlinks file="Note Title" format=json  # Check note connectivity
obsidian vault=KB orphans                                  # Find unconnected notes to include
obsidian vault=KB create name="MOC - Topic" content="..."  # Create the MOC note
obsidian vault=KB append file="MOC - Topic" content="..."  # Update existing MOC
```

## Steps

1. **Identify the topic** from the user's input

2. **Scan the vault** for related notes using CLI:

   ```bash
   obsidian vault=KB search query="productivity" format=json   # Content/title matches
   obsidian vault=KB tag name="productivity" verbose            # Tag matches
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

4. **Create or update the MOC** via CLI:

   ```bash
   obsidian vault=KB create name="MOC - Productivity" content="---\ndate: YYYY-MM-DD\ntype: moc\ntags: [productivity]\n---\n\n# MOC - Productivity\n\n{grouped_links}" open
   ```

   - Save to the user's chosen folder (suggest `40_Knowledge` or root)
   - Falls back to `write_to_file` if Obsidian is not running

5. **Handle existing MOCs**:
   - Check if a MOC for this topic exists: `obsidian vault=KB search query="MOC - Productivity"`
   - If it exists, read it with `obsidian read`, show what's new, and offer to merge via `obsidian append`

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
