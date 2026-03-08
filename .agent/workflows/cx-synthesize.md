---
description: Combine multiple notes on a topic into a higher-level insight note with source attribution.
quick_summary: "Find related notes → read all → produce synthesis with [[wikilink]] attribution."
requires_mcp: []
recommends_mcp: [sequential-thinking]
---

# /cx-synthesize - Synthesize Notes

**Goal**: Read multiple notes on a topic and produce a synthesis note that captures the higher-level insight, linking back to sources.

> **Agent Reference**:
>
> - [synthesizer](../agents/synthesizer.md) — Pattern finding, insight building
>
> **Skill Reference**:
>
> - [pkm-methodology](../skills/pkm-methodology/SKILL.md) — Synthesis methodology
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — Wikilink format, file creation, CLI commands

## When to Use

- You have 3+ notes on a topic and want to see the bigger picture
- You're preparing to write about a topic and need to consolidate your thinking
- You notice recurring themes across your notes
- During a review session when patterns emerge

## CLI Commands Used

```bash
obsidian search query="..." format=json          # Find related notes by topic
obsidian tag name="tagname" verbose               # Find notes by tag
obsidian read file="Note Title"                   # Read each source note
obsidian backlinks file="Note Title" format=json  # Check connectivity
obsidian create name="Synthesis: Topic" template=synthesis  # Create synthesis note
obsidian append file="Source Note" content="..."  # Add backlink to source notes
```

## Steps

1. **Identify the topic**:
   - Use the topic provided by the user
   - Search the vault for related notes:

   ```bash
   obsidian search query="productivity" format=json
   obsidian tag name="productivity" verbose
   ```

2. **Present source notes**:

   ```
   📚 Found 5 notes related to "productivity":

   1. My Productivity Workflow.md (10_Reflection)
   2. The Perfect Work Day.md (10_Reflection)
   3. Building Agentic apps.md (00_Inbox)
   4. Habit Formation.md (20_Ideas)
   5. Deep Work Notes.md (40_Reference)

   Synthesize all, or select specific notes?
   ```

3. **Read all selected source notes** via CLI:

   ```bash
   obsidian read file="My Productivity Workflow"
   obsidian read file="The Perfect Work Day"
   # ... etc
   ```

4. **Synthesize** (using the Synthesizer agent):
   - Find themes that repeat across notes
   - Identify contradictions or tensions (these are gold — flag them)
   - Produce a coherent insight that is more than a summary
   - Write in the user's voice (match the style of existing notes)

5. **Draft the synthesis note** using the `synthesis.md` template:
   - Title: `Synthesis: {topic}`
   - Insight section with the synthesized understanding
   - Sources section with `[[wikilinks]]` to each source note
   - Open questions section for gaps or unresolved tensions

6. **Present the draft** for review

7. **Save on confirmation** via CLI:
   ```bash
   obsidian create name="Synthesis: Productivity" template=synthesis content="..." open
   ```

   - Write to the appropriate folder (suggest `20_Ideas` or user-chosen)
   - Optionally add a backlink to the synthesis from each source note:
   ```bash
   obsidian append file="My Productivity Workflow" content="\n\nSynthesized in [[Synthesis: Productivity]]"
   ```

## Usage

```bash
# Synthesize by topic
/cx-synthesize "productivity"

# Synthesize specific notes
/cx-synthesize "My Productivity Workflow" "The Perfect Work Day" "Deep Work Notes"

# Synthesize by tag
/cx-synthesize #career
```

## Key Principles

- **Insight, not summary** — don't just concatenate notes; find what they mean together
- **Attribute everything** — every claim should link to its source note
- **Flag tensions** — contradictions between notes are often the most valuable insights
- **User's voice** — match the writing style of the user's existing notes

## Next Steps

- `/cx-map` — Create a navigational Map of Content for the topic
- `/cx-connect` — Add connections from the synthesis to other notes
