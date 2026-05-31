---
description: Combine notes into a higher-level insight.
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
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — Wikilink format, file creation

## When to Use

- You have 3+ notes on a topic and want to see the bigger picture
- You're preparing to write about a topic and need to consolidate your thinking
- You notice recurring themes across your notes
- During a review session when patterns emerge

## Path Resolution

All vault paths start with `c:\HQ\KB\`. Use `grep_search` to find notes by content or tags, `list_dir` to enumerate folders.

## Steps

1. **Identify the topic**:
   - Use the topic provided by the user
   - Search the vault for related notes:

   ```
   grep_search: Query="productivity", SearchPath="c:\HQ\KB\", MatchPerLine=true
   ```

   Also search by tag:

   ```
   grep_search: Query="tags:.*productivity", SearchPath="c:\HQ\KB\", IsRegex=true, MatchPerLine=true
   ```

2. **Present source notes**:

   ```
   📚 Found 5 notes related to "productivity":

   1. My Productivity Workflow.md (20_Journal)
   2. The Perfect Work Day.md (20_Journal)
   3. Building Agentic apps.md (00_Inbox)
   4. Habit Formation.md (30_Ideas)
   5. Deep Work Notes.md (40_Knowledge)

   Synthesize all, or select specific notes?
   ```

3. **Read all selected source notes** via `view_file`:

   ```
   view_file: c:\HQ\KB\20_Journal\My Productivity Workflow.md
   view_file: c:\HQ\KB\20_Journal\The Perfect Work Day.md
   # ... etc (issue all reads in parallel)
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

7. **Save on confirmation** via `write_to_file`:

   ```
   write_to_file: c:\HQ\KB\30_Ideas\Synthesis - Productivity.md
   ```

   Content:
   ```markdown
   ---
   date: YYYY-MM-DD
   type: synthesis
   tags: [productivity]
   ---

   # Synthesis: Productivity

   {insight}

   ## Sources
   {source_links}

   ## Open Questions
   {questions}
   ```

   - Write to the appropriate folder (suggest `30_Ideas` or user-chosen)
   - Optionally add a backlink from each source note using read-modify-write:
     - Read source note with `view_file`
     - Append `\n\nSynthesized in [[Synthesis: Productivity]]`
     - Write back with `write_to_file` (overwrite)

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
