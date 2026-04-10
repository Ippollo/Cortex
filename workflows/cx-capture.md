---
description: Instant note capture to Obsidian inbox.
quick_summary: "Capture a thought → timestamped markdown in vault inbox. Zero friction."
requires_mcp: []
recommends_mcp: []
---

# /cx-capture - Quick Capture

**Goal**: Capture a thought, idea, or learning instantly into the Obsidian vault without leaving Antigravity.

> **Skill Reference**:
>
> - [obsidian-conventions](../skills/obsidian-conventions/SKILL.md) — File naming, tag format, vault path, CLI commands

## When to Use

- You have a thought or idea right now and want to save it
- You learned something and want to record it before you forget
- You want to bookmark a topic for later exploration
- Any time — this should be the lowest-friction action in the toolkit

## Steps

// turbo-all

1. **Read vault config** from `../config.md`:
   - Get the vault path (`C:\Workspace\KB`) and inbox folder name (`00_Inbox`)

2. **Parse the user's input**:
   - Extract the content (everything the user typed after `/cx-capture`)
   - Extract any `#tags` from the content
   - Generate a title: use the first sentence or a slugified summary if no clear title
   - Generate a filename: `{title}.md`
   - **Auto-classify based on pattern detection**: Scan the content for these structural patterns and set frontmatter accordingly. Merge auto-detected tags with any user-provided tags.
     - `Decision:` at start → `type: action`, `status: todo`, `tags: [decision]`
     - `[Name] — ` at start → `type: fleeting`, `tags: [person]`
     - `Insight:` at start → `type: fleeting`, `tags: [insight]`
     - `Meeting with ` at start → `type: fleeting`, `tags: [meeting]`
     - `Saving from ` at start → `type: fleeting`, `tags: [ai-save]`, add `source:` to frontmatter
     - No pattern match → `type: fleeting` (default)

3. **Check for source link**:
   - If the capture references external content (a post, article, video, tweet, etc.) and no URL was provided, **ask the user for the link before creating the note**
   - This is the one exception to the "no questions asked" principle — sources need URLs

4. **Create the note** via `write_to_file`:

   Write directly to the vault inbox directory. Do NOT use the Obsidian CLI — it hangs frequently on create commands and `write_to_file` produces identical results with zero risk.

   ```
   Target: {vault_path}/{inbox_folder}/{title}.md
   ```

   Build frontmatter and content as markdown. If the file already exists, append a numeric suffix and retry.

5. **Confirm**:
   - Report: `✅ Captured → {inbox_folder}/{filename}`
   - Suggest: "Run `/cx-inbox` later to process and file this note."

## Usage

```bash
# Decision pattern
/cx-capture Decision: Use Flash for routine tasks. Context: Token cost analysis. Owner: Chris.

# Meeting pattern
/cx-capture Meeting with design team about dashboard. Key points: cut three panels. Action items: send API spec.

# Insight pattern
/cx-capture Insight: Onboarding flow assumes users know permissions. Triggered by: watching UX test.

# Person pattern
/cx-capture Marcus — mentioned he wants to move to the platform team.

# AI Save pattern
/cx-capture Saving from Claude: Framework for evaluating vendor proposals (score on integration effort).

# Unstructured (Default)
/cx-capture I should explore using Zettelkasten for my knowledge management
```

## Key Principles

- **Speed over perfection** — the note doesn't need to be clean, just captured
- **No questions asked** — don't prompt the user for tags, folders, or metadata unless they explicitly asked for help. The one exception: if the capture references external content, always ask for the source URL.
- **Inbox is temporary** — everything captured here will be processed by `/cx-inbox` later

## Next Steps

- `/cx-inbox` — Process captured notes (file, expand, connect, or discard)
- `/cx-connect` — Find related notes for a specific capture
