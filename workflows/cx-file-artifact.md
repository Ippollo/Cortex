---
description: File a conversation artifact (analysis, research, synthesis) from the Antigravity brain/ directory into the Obsidian vault so insights compound rather than evaporate.
quick_summary: "Bridge brain/{id}/ → KB vault. File outputs so every query enriches the knowledge base."
requires_mcp: []
recommends_mcp: []
---

# /cx-file-artifact - File Artifact to Vault

**Goal**: Take a conversation artifact (markdown file from the Antigravity `brain/` directory) and file it into the Obsidian vault as a permanent note — complete with proper frontmatter, tags, folder placement, and wikilinks to related notes.

> **Skill Reference**:
>
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — File naming, frontmatter, folder structure, CLI commands

## When to Use

- You just finished a research or analysis conversation and have a useful output artifact
- You want an AI-generated synthesis, comparison, or plan to live in the vault for future reference
- You have a `brain/{conversation-id}/` file worth keeping beyond the conversation
- After running `/cx-synthesize` — to file the synthesis output into the vault

## Key Principle

Artifacts that stay in `brain/` evaporate when the conversation ends. Artifacts filed into the vault become part of the searchable, connectable knowledge base. Every query you run should add up, not disappear.

## Steps

1. **Identify the artifact**:
   - If the user provides a path: use it directly
   - If the user describes it vaguely (e.g., "the analysis from earlier"): list recent artifacts in the current `brain/{conversation-id}/` directory and ask which one
   - Read the artifact content via `view_file`

2. **Determine vault target**:

   Choose the appropriate folder based on content type:

   | Content Type | Folder |
   |---|---|
   | Research analysis, comparisons, technical evaluations | `40_Knowledge/` |
   | Ideas, explorations, "what if" thinking | `30_Ideas/` |
   | Plans, decisions, project strategy | `10_Projects/` |
   | Reflections, lessons learned | `20_Journal/` |
   | Reference material (frameworks, patterns) | `40_Knowledge/` |

   When uncertain, ask the user. Default to `40_Knowledge/` for AI-generated analysis.

3. **Generate a clean title**:
   - Derive from the artifact's `#` heading or a summary of the content
   - Format: descriptive, title-case, no date prefix (date goes in frontmatter)
   - Example: `LLM Knowledge Base Pattern - HQ Analysis`

4. **Build frontmatter**:
   ```yaml
   ---
   date: YYYY-MM-DD          # Today's date
   type: permanent           # Usually permanent for filed analysis; synthesis for cx-synthesize outputs
   tags: []                  # Choose from vault tag vocabulary: ideas, productivity, ai, career, etc.
   source: conversation      # Or the specific source if the artifact was generated from one
   ---
   ```

5. **Clean the content**:
   - Strip any artifact-specific metadata (conversation IDs, file paths, internal references)
   - Convert any absolute Antigravity paths to wikilinks if they reference vault notes
   - Preserve tables, headings, and structured content
   - Remove implementation plan boilerplate that's irrelevant outside the conversation context

6. **Check for collisions**:
   - Use `obsidian file file="Title"` to verify the title doesn't already exist
   - If collision: append ` 2` or add more specificity to the title

7. **Write the note** via `write_to_file`:
   ```
   Target: C:\Workspace\KB\{folder}\{title}.md
   ```
   Use `write_to_file` directly (not Obsidian CLI create — cx-capture pattern, avoids CLI hanging risk).

8. **Connect to related notes** (optional but recommended):
   - Run a quick `obsidian search:context` for the note's main concepts
   - Suggest 2–3 existing vault notes to link
   - Append a `## Related` section with approved wikilinks via `obsidian append`

9. **Confirm**:
   - Report: `✅ Filed → {folder}/{title}.md`
   - Suggest: "Run `/cx-connect` to find more connections for this note."
   - Optionally: offer to commit the vault repo if relevant ("This is in your KB repo — do you want to commit?")

## Usage

```
/cx-file-artifact
→ Agent lists recent artifacts from current brain dir and asks which one

/cx-file-artifact the Karpathy knowledge base analysis
→ Agent locates the matching artifact and proceeds

/cx-file-artifact C:\Users\YourUser\.gemini\antigravity\brain\9aee74df-...\analysis_karpathy.md
→ Agent uses the explicit path
```

## Edge Cases

- **Multiple artifacts**: If the user wants to file several at once, process them one at a time and confirm each
- **Code-heavy artifacts**: If the artifact is mostly code (e.g., a script), file to `40_Knowledge/` with `type: reference` and note that executable scripts belong in their project repos, not the vault
- **Already in vault**: If a similar note exists, offer to merge/append rather than create a duplicate — use `obsidian search:context` to detect near-duplicates first

## Next Steps

- `/cx-connect` — Find and add wikilinks to the newly filed note
- `/cx-inbox` — Process any accumulated inbox notes
