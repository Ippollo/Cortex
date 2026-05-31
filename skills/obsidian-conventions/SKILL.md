---
name: Obsidian Conventions
description: Obsidian vault file format, wikilink syntax, tag conventions, and vault structure rules. Loaded when agents create or modify files in the vault.
version: 4.0.0
triggers:
  - obsidian
  - wikilink
  - vault
  - tag format
  - note format
  - file naming
metadata:
  pattern: tool-wrapper
---

# Obsidian Conventions

Rules and patterns for working with an Obsidian vault. All agents and workflows that read from or write to the vault MUST follow these conventions.

## Vault Access

All vault operations use **file-system tools exclusively**. The Obsidian CLI is deprecated due to reliability issues (hanging on commands).

> **Reference**: See `c:\HQ\vault-manual.md` for the authoritative vault access rules and `c:\HQ\decisions.md` for the deprecation rationale.

### Tool Mapping

| Operation           | Tool                      | Example                                                      |
| ------------------- | ------------------------- | ------------------------------------------------------------ |
| Read a note         | `view_file`               | `view_file: c:\HQ\KB\30_Ideas\My Note.md`                   |
| Search vault        | `grep_search`             | `grep_search: Query="productivity", SearchPath="c:\HQ\KB\"` |
| Search with context | `grep_search`             | `grep_search: Query="...", MatchPerLine=true`                |
| List files          | `list_dir`                | `list_dir: c:\HQ\KB\00_Inbox`                               |
| Create a note       | `write_to_file`           | `write_to_file: c:\HQ\KB\30_Ideas\New Note.md`              |
| Append to a note    | read-modify-write         | `view_file` → modify content → `write_to_file` (overwrite)  |
| Move a note         | PowerShell `Move-Item`    | `Move-Item "source.md" "dest.md"`                            |
| Rename a note       | PowerShell `Rename-Item`  | `Rename-Item "old.md" "new.md"` + grep for wikilink updates  |
| Delete a note       | PowerShell `Remove-Item`  | `Remove-Item "note.md"`                                      |
| Find backlinks      | `grep_search`             | `grep_search: Query="[[Note Title]]", SearchPath="c:\HQ\KB\"` |
| Find notes by tag   | `grep_search`             | `grep_search: Query="tags:.*career", IsRegex=true`           |
| Get file metadata   | PowerShell `Get-Item`     | `(Get-Item "note.md").LastWriteTime`                         |

### Path Resolution

File-system tools require **full paths**, not note titles. To locate a note by title:
1. `grep_search` for the filename pattern across `c:\HQ\KB\`
2. `list_dir` to enumerate the target folder
3. All vault paths start with `c:\HQ\KB\`

### Trade-offs vs. CLI

These operations have **reduced fidelity** compared to the CLI. This is acceptable:
- **Backlinks**: `grep_search` for `[[Title]]` misses aliased links (`[[Title|Display]]`). Partial match is acceptable for discovery.
- **Orphan detection**: Requires grepping for every note title — expensive. Use as a heuristic, not a guarantee.
- **Move + link update**: When renaming (not just moving), manually `grep_search` for `[[old name]]` and update. Folder-only moves need no link updates (Obsidian resolves by filename).

## Wikilinks

### Syntax

```markdown
[[Note Title]]               # Basic link
[[Note Title|Display Text]]  # Link with alias
[[Note Title#Heading]]       # Link to a heading
[[Note Title#Heading|Display]] # Heading link with alias
```

### Resolution Rules

- Obsidian resolves wikilinks by **filename only** (not path)
- `[[My Note]]` matches `00_Inbox/My Note.md` or `30_Ideas/My Note.md`
- If there are duplicate filenames, Obsidian uses the shortest path. Cortex should use full relative paths to avoid ambiguity: `[[subfolder/My Note]]`
- Links are **case-insensitive** in Obsidian but preserve the case you type

### When Creating Links

- Match the exact filename (minus `.md`) for the link target
- Prefer the note's title as display text
- Always verify the target note exists before suggesting a link — use `grep_search` for the filename
- If the target doesn't exist, Obsidian will show it as a "potential note" (greyed out in graph)

## Tags

### Current Vault Convention

This vault uses **YAML frontmatter tags** as the primary tagging method:

```yaml
---
date: 2026-03-07
type: permanent
tags: [productivity, career]
---
```

### Tag Rules

- Tags go in the YAML frontmatter `tags:` array — NOT inline in the note body
- Format: lowercase, hyphenated for multi-word (e.g., `personal-growth`)
- Obsidian's Properties view will render these natively
- **Discovery**: Use `grep_search` with `Query="tags:"` to survey tag usage across the vault

### Standardized Tag Vocabulary

| Tag               | For notes about                        |
| ----------------- | -------------------------------------- |
| `career`          | Job search, work, professional growth  |
| `relationships`   | Marriage, family, friendships          |
| `productivity`    | Workflows, habits, systems             |
| `health`          | Physical and mental well-being         |
| `ideas`           | Business ideas, concepts, explorations |
| `parenting`       | Kids, fatherhood                       |
| `personal-growth` | Values, self-reflection, therapy       |

When tagging a note, choose from this list first. Only create new tags if none of these fit. Use `grep_search` to check current tag usage patterns.

## File Naming

### Convention

- Use descriptive titles with spaces: `Building Agentic apps.md`
- Date is tracked in frontmatter, not the filename.
- No special characters that break file systems: avoid `< > : " / \ | ? *`
- Keep titles concise but descriptive — they become the wikilink target

### Deduplication

- Before creating a file, check if a file with the same name exists via `grep_search` or `list_dir`
- If collision: append a numeric suffix: `My Note 2.md`
- Never overwrite existing notes silently

## Frontmatter

### Current Vault Policy

All notes MUST have YAML frontmatter with at minimum:

```yaml
---
date: YYYY-MM-DD
type: fleeting | permanent | reflection | reference | moc | daily | synthesis | literature | action
tags: []
---
```

- `date`: The date the note was created or last meaningfully edited
- `type`: The note's category — determines which template was used
- `tags`: Array of tags from the standardized vocabulary (see Tags section)
- Additional fields may be added per template (e.g., `source:` and `author:` for literature notes)

### Action-Specific Fields

Notes with `type: action` support these optional fields:

```yaml
---
date: 2026-03-25
type: action
tags: [career, content]
status: todo              # todo | in-progress | done | parked
priority: p2              # p1 (urgent) | p2 (normal) | p3 (low)
due: 2026-03-30           # optional — date-sensitive items only
project: hq               # optional (hq, heredara, reminders)
section: content           # optional (general, content, specwright, cortex, bugs, add-change, future, test)
---
```

- `status`: Task lifecycle state
- `priority`: Urgency level
- `due`: Target completion date (not a reminder — no push notifications)
- `project`: Maps to a Todoist-equivalent project grouping
- `section`: Sub-grouping within a project

### Frontmatter Rules

- Always place frontmatter at the very top of the file
- Use `---` delimiters
- Tags in frontmatter do NOT use `#` prefix (just the word)
- Obsidian's Properties view renders frontmatter natively

## Folder Structure

### Current Vault Layout

```
c:\HQ\KB\
├── 00_Inbox/            # Capture zone — unprocessed notes
├── 10_Projects/         # Actionable work (tasks, reminders, project items)
├── 20_Journal/          # Personal reflections, journals, values, people notes
├── 30_Ideas/            # Ideas, concepts, project seeds, explorations
├── 40_Knowledge/        # Reference material, business frameworks, career data
├── 50_Finance/          # Financial data (accounts, imports, monthly)
├── 99_System/           # System infrastructure (not regular notes)
│   ├── Archive/         # Archived raw material, old research
│   ├── Attachments/     # Images, files, media
│   └── Templates/       # Obsidian note templates
├── .obsidian/           # Obsidian config (DO NOT TOUCH)
└── .git/                # Version control
```

### Folder Rules

- **NEVER** modify anything in `.obsidian/`
- **NEVER** modify `.stfolder` or `.stignore`
- Numbered prefixes (`00_`, `10_`, etc.) control sort order
- New folders require user confirmation
- When moving notes, use PowerShell `Move-Item`. Since Obsidian resolves wikilinks by filename (not path), moving to a different folder does NOT require link updates.
- Prefer flat folders with tags for sub-categorization over deep subfolder trees

## Moving Files

### Preferred: PowerShell

```powershell
# Move a note to a new folder (no link updates needed — Obsidian resolves by filename)
Move-Item "c:\HQ\KB\00_Inbox\My Note.md" "c:\HQ\KB\30_Ideas\My Note.md"

# Rename a note (requires link updates)
Rename-Item "c:\HQ\KB\30_Ideas\Old Title.md" "New Title.md"
# Then: grep_search for [[Old Title]] across the vault and update references
```

### Important

- Link updates only matter if the **filename** changes (not the folder) — Obsidian resolves by filename, not path.
- If only the folder changes and the filename stays the same, no link updates are needed.
- When renaming, scan the vault with `grep_search` for `[[Old Title]]` and update each reference.

## File Writing

### Method: `write_to_file`

```
write_to_file: c:\HQ\KB\{folder}\{title}.md
```

- UTF-8 encoding (standard for Obsidian)
- Unix line endings (`\n`) preferred, but Windows (`\r\n`) is acceptable
- For appending, use read-modify-write: `view_file` → modify → `write_to_file` (overwrite)

### Syncthing Compatibility

- Changes are synced automatically — no special handling
- Avoid rapid sequential writes to the same file (Syncthing may conflict)
- After writing, the note is immediately visible in Obsidian (if open, it auto-refreshes)
