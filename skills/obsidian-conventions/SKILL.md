---
name: Obsidian Conventions
description: Obsidian vault file format, wikilink syntax, tag conventions, CLI commands, and compatibility rules. Loaded when agents create or modify files in the vault.
version: 3.0.0
triggers:
  - obsidian
  - obsidian cli
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

## Obsidian CLI

The Obsidian CLI (v1.12+) is the **preferred** way to interact with the vault from Cortex. It connects to the running Obsidian app and leverages its link graph, search index, and template engine.

> **Requirement**: Obsidian desktop must be running. If Obsidian is closed, fall back to raw filesystem operations.

### Key Commands

| Operation           | CLI Command                                                    | Replaces                        |
| ------------------- | -------------------------------------------------------------- | ------------------------------- |
| Create a note       | `obsidian create name="Title" content="..." template=fleeting` | `write_to_file`                 |
| Read a note         | `obsidian read file="Title"`                                   | `view_file`                     |
| Append to a note    | `obsidian append file="Title" content="..."`                   | Manual read + rewrite           |
| Move a note         | `obsidian move file="Title" to="30_Ideas"`                     | Read/write/delete + link scan   |
| Rename a note       | `obsidian rename file="Title" name="New Title"`                | Manual + link updates           |
| Delete a note       | `obsidian delete file="Title"`                                 | Manual delete                   |
| Search vault        | `obsidian search query="..." format=json`                      | `grep_search`                   |
| Search with context | `obsidian search:context query="..." format=json`              | `grep_search`                   |
| List files          | `obsidian files folder="00_Inbox"`                             | `list_dir`                      |
| Get file info       | `obsidian file file="Title"`                                   | File system stats               |
| Get backlinks       | `obsidian backlinks file="Title" format=json`                  | Manual wikilink grep            |
| Get outgoing links  | `obsidian links file="Title"`                                  | Manual wikilink grep            |
| Find orphan notes   | `obsidian orphans`                                             | Manual link analysis            |
| Find dead-end notes | `obsidian deadends`                                            | Manual link analysis            |
| List tags           | `obsidian tags counts format=json`                             | Manual tag grep                 |
| Tag info            | `obsidian tag name="productivity" verbose`                     | `grep_search` for tags          |
| Open daily note     | `obsidian daily`                                               | Manual date-based file creation |
| Append to daily     | `obsidian daily:append content="..."`                          | Manual file append              |
| Daily note path     | `obsidian daily:path`                                          | Manual path construction        |
| Read properties     | `obsidian property:read name="..." file="..."`                 | Parse YAML manually             |
| Set properties      | `obsidian property:set name="..." value="..." file="..."`      | Manual YAML edit                |
| List templates      | `obsidian templates`                                           | `list_dir` on templates folder  |
| Read template       | `obsidian template:read name="..." resolve`                    | `view_file`                     |
| Recent files        | `obsidian recents`                                             | Sort files by mtime             |
| Execute JS          | `obsidian eval code="..."`                                     | N/A — new capability            |

### CLI Conventions

- **File targeting**: Use `file=Title` (wikilink-style resolution) or `path=folder/file.md` (exact path)
- **Output formats**: Most list commands support `format=json|tsv|csv` — prefer `format=json` for programmatic use
- **Vault targeting**: Run CLI from within the vault directory, or use `vault=KB` as the first parameter. Prefer `vault=KB` for reliability since Antigravity's CWD may vary
- **Multiline content**: Use `\n` for newlines in `content=` parameters
- **Templates**: The `template=` parameter requires the Templates core plugin to be enabled with a configured template folder in Obsidian settings. If not configured, build note content in the `content=` parameter directly instead

## Wikilinks

### Syntax

```markdown
[[Note Title]] # Basic link
[[Note Title|Display Text]] # Link with alias
[[Note Title#Heading]] # Link to a heading
[[Note Title#Heading|Display]] # Heading link with alias
```

### Resolution Rules

- Obsidian resolves wikilinks by **filename only** (not path)
- `[[My Note]]` matches `00_Inbox/My Note.md` or `30_Ideas/My Note.md`
- If there are duplicate filenames, Obsidian uses the shortest path. Cortex should use full relative paths to avoid ambiguity: `[[subfolder/My Note]]`
- Links are **case-insensitive** in Obsidian but preserve the case you type
- **CLI equivalent**: `obsidian backlinks file="My Note"` returns all notes linking to it; `obsidian links file="My Note"` returns all outgoing links

### When Creating Links

- Match the exact filename (minus `.md`) for the link target
- Prefer the note's title as display text
- Always verify the target note exists before suggesting a link — use `obsidian file file="Title"` to check
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
- **CLI**: Use `obsidian tags counts` to check existing tag usage

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

When tagging a note, choose from this list first. Only create new tags if none of these fit. Use `obsidian tags counts sort=count` to see current usage.

## File Naming

### Convention

- Use descriptive titles with spaces: `Building Agentic apps.md`
- For captures with timestamps: `YYYY-MM-DD Title.md` (e.g., `2026-03-06 Quick thought about X.md`)
- No special characters that break file systems: avoid `< > : " / \ | ? *`
- Keep titles concise but descriptive — they become the wikilink target

### Deduplication

- Before creating a file, check if a file with the same name exists
- If collision: append a numeric suffix: `My Note 2.md`
- Never overwrite existing notes silently
- **CLI**: `obsidian create` will error if the file exists (unless `overwrite` flag is set)

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
C:\Workspace\Notepad\
├── 00_Inbox/            # Capture zone — unprocessed notes
├── 10_Projects/         # Actionable work (tasks, reminders, project items)
├── 20_Journal/          # Personal reflections, journals, values, people notes
├── 30_Ideas/            # Ideas, concepts, project seeds, explorations
├── 40_Knowledge/        # Reference material, business frameworks, career data
├── 70_Finance/          # Financial data (accounts, imports, monthly)
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
- When moving notes, use `obsidian move` which auto-updates internal links
- Prefer flat folders with tags for sub-categorization over deep subfolder trees

## Moving Files

### Preferred: Obsidian CLI

```bash
# Move a note to a new folder (auto-updates links)
obsidian move file="My Note" to="30_Ideas"

# Rename a note (auto-updates links)
obsidian rename file="Old Title" name="New Title"
```

The CLI handles link updates automatically when Obsidian's "Automatically update internal links" setting is enabled.

### Fallback: Raw Filesystem (when Obsidian is not running)

1. Read the file content
2. Write the file to the new location
3. Delete the file from the old location
4. Scan ALL other files in the vault for `[[wikilinks]]` that reference the moved file
5. Update those links if the filename changed

### Important

- Link updates only matter if the **filename** changes (not the folder) — Obsidian resolves by filename, not path.
- If only the folder changes and the filename stays the same, no link updates are needed.

## File Writing

### Preferred: Obsidian CLI

```bash
# Create with template
obsidian create name="My Note" template=fleeting content="Extra content"

# Append content
obsidian append file="My Note" content="New paragraph"

# Prepend after frontmatter
obsidian prepend file="My Note" content="Added to top"
```

### Fallback: Raw Filesystem

- UTF-8 encoding (standard for Obsidian)
- Unix line endings (`\n`) preferred, but Windows (`\r\n`) is acceptable

### Syncthing Compatibility

- Changes are synced automatically — no special handling
- Avoid rapid sequential writes to the same file (Syncthing may conflict)
- After writing, the note is immediately visible in Obsidian (if open, it auto-refreshes)
