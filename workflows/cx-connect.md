---
description: Find and add wikilinks between related notes using AI-powered semantic matching.
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
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — Wikilink syntax, CLI commands

## When to Use

- After filing a note from the inbox
- When you know a note should be connected but aren't sure to what
- When reviewing an older note and wanting to enrich it
- After adding several new notes on a topic

## CLI Commands Used

```bash
obsidian vault=Notepad read file="Note Title"                    # Read the target note
obsidian vault=Notepad backlinks file="Note Title" format=json   # Find what links to it
obsidian vault=Notepad links file="Note Title"                   # Find its outgoing links
obsidian vault=Notepad tags file="Note Title"                    # Get its tags
obsidian vault=Notepad search query="..." format=json            # Find content-similar notes
obsidian vault=Notepad tag name="tagname" verbose                # Find notes sharing a tag
obsidian vault=Notepad orphans                                   # Find unconnected notes
obsidian vault=Notepad append file="Note Title" content="..."    # Add approved links
```

## Steps

1. **Identify the target note**:
   - If the user specifies a note: use that
   - If no note specified: ask which note to connect, or offer to scan recent additions

2. **Read the target note** via CLI:

   ```bash
   obsidian vault=Notepad read file="Note Title"
   ```

3. **Scan the vault** for related notes using CLI:
   - **Existing links**: `obsidian links file="Note Title"` — check what it already links to (avoid re-suggesting)
   - **Backlinks**: `obsidian backlinks file="Note Title"` — see what already links to it
   - **Tag overlap**: `obsidian tags file="Note Title"` → then `obsidian tag name="tagname" verbose` for each tag
   - **Content similarity**: `obsidian vault=Notepad search query="key concepts from note" format=json` + AI semantic matching
   - **Title matching**: `obsidian vault=Notepad search query="title keywords"` to find related titles

4. **Present suggestions** (ranked by relevance):

   ```
   🔗 Suggested connections for "My Productivity Workflow":

   1. [[Building Agentic apps]] — both discuss optimizing personal workflows
   2. [[The Perfect Work Day]] — related productivity framework
   3. [[Habit Formation Notes]] — references building habits

   Approve (a)ll, approve (s)ome, or (n)one?
   ```

5. **Add approved links** via CLI:

   ```bash
   obsidian vault=Notepad append file="Note Title" content="\n## Related\n- [[Building Agentic apps]]\n- [[The Perfect Work Day]]"
   ```

   - Append a `## Related` section to the note (if it doesn't have one)
   - Add each approved `[[wikilink]]` as a list item
   - Optionally: add a reciprocal link in the connected note (ask user)

6. **Report**: Show the updated note and confirm links were added

## Usage

```bash
# Connect a specific note
/cx-connect "My Productivity Workflow"

# Connect the most recently captured note
/cx-connect latest

# Connect all notes in a folder
/cx-connect --folder "20_Ideas"
```

## Key Principles

- **Quality over quantity** — suggest 3-5 strong connections, not 20 weak ones
- **Bidirectional is optional** — not every link needs a backlink
- **Explain the connection** — "both discuss X" is more useful than "related"
- **Respect existing structure** — append to `## Related` section if it exists, create it if not

## Next Steps

- `/cx-synthesize` — Combine connected notes into a higher-level insight
- `/cx-map` — Create a Map of Content for a well-connected topic
