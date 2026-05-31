---
description: AI-powered semantic wikilinking.
quick_summary: "Scan vault for related notes → suggest [[wikilinks]] → user approves each."
requires_mcp: []
recommends_mcp: [sequential-thinking]
---

# /cx-connect - Connect Notes

**Goal**: Find meaningful connections between a note and the rest of the vault, then add `[[wikilinks]]` the user approves.

> **Agent Reference**:
>
> - [librarian](../agents/librarian.md) — Semantic similarity, vault awareness
>
> **Skill Reference**:
>
> - [pkm-methodology](../skills/pkm-methodology/SKILL.md) — Connection principles
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — Wikilink syntax, vault structure

## When to Use

- After filing a note from the inbox
- When you know a note should be connected but aren't sure to what
- When reviewing an older note and wanting to enrich it
- After adding several new notes on a topic

## Path Resolution

File-system tools require full paths, not note titles. To locate a note:
1. If the user gives a title, use `grep_search` for the filename across `c:\HQ\KB\`
2. If the user gives a folder, use `list_dir` on that folder
3. All vault paths start with `c:\HQ\KB\`

## Steps

1. **Identify the target note**:
   - If the user specifies a note: use that
   - If no note specified: ask which note to connect, or offer to scan recent additions

2. **Read the target note** via `view_file`:

   ```
   view_file: c:\HQ\KB\{folder}\{filename}.md
   ```

3. **Scan the vault** for related notes using file-system tools:
   - **Existing links**: Read the note content and extract any `[[wikilinks]]` already present (avoid re-suggesting)
   - **Backlinks**: `grep_search` for `[[Note Title]]` across the vault to find what already links to it
   - **Tag overlap**: Extract tags from the note's frontmatter, then `grep_search` for notes with the same tags
   - **Content similarity**: `grep_search` for key concepts from the note + AI semantic matching on results
   - **Title matching**: `grep_search` for title keywords to find related notes

4. **Present suggestions** (ranked by relevance):

   ```
   🔗 Suggested connections for "My Productivity Workflow":

   1. [[Building Agentic apps]] — both discuss optimizing personal workflows
   2. [[The Perfect Work Day]] — related productivity framework
   3. [[Habit Formation Notes]] — references building habits

   Approve (a)ll, approve (s)ome, or (n)one?
   ```

5. **Add approved links** via read-modify-write:
   - Read the note with `view_file`
   - Append a `## Related` section (if it doesn't have one)
   - Add each approved `[[wikilink]]` as a list item
   - Write back with `write_to_file` (overwrite)
   - Optionally: add a reciprocal link in the connected note (ask user)

6. **Report**: Show the updated note and confirm links were added

## Usage

```bash
# Connect a specific note
/cx-connect "My Productivity Workflow"

# Connect the most recently captured note
/cx-connect latest

# Connect all notes in a folder
/cx-connect --folder "30_Ideas"
```

## Key Principles

- **Quality over quantity** — suggest 3-5 strong connections, not 20 weak ones
- **Bidirectional is optional** — not every link needs a backlink
- **Explain the connection** — "both discuss X" is more useful than "related"
- **Respect existing structure** — append to `## Related` section if it exists, create it if not

## Next Steps

- `/cx-synthesize` — Combine connected notes into a higher-level insight
- `/cx-map` — Create a Map of Content for a well-connected topic
