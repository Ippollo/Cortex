---
name: Obsidian Conventions
description: Obsidian vault file format, wikilink syntax, tag conventions, and compatibility rules. Loaded when agents create or modify files in the vault.
version: 1.0.0
triggers:
  - obsidian
  - wikilink
  - vault
  - tag format
  - note format
  - file naming
---

# Obsidian Conventions

Rules and patterns for working with an Obsidian vault. All agents and workflows that read from or write to the vault MUST follow these conventions.

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
- `[[My Note]]` matches `00_Inbox/My Note.md` or `20_Ideas/My Note.md`
- If there are duplicate filenames, Obsidian uses the shortest path. Cortex should use full relative paths to avoid ambiguity: `[[subfolder/My Note]]`
- Links are **case-insensitive** in Obsidian but preserve the case you type

### When Creating Links

- Match the exact filename (minus `.md`) for the link target
- Prefer the note's title as display text
- Always verify the target note exists before suggesting a link
- If the target doesn't exist, Obsidian will show it as a "potential note" (greyed out in graph)

## Tags

### Current Vault Convention

This vault uses **inline tags** in the note body, NOT YAML frontmatter tags:

```markdown
# My Note

This is about productivity and workflows.

#productivity #workflows
```

### Tag Rules

- Format: `#tag` or `#parent/child` for hierarchy
- Place tags at the **end of the note** (current vault pattern) or naturally inline
- Do NOT add tags via YAML frontmatter — the vault doesn't use it
- Tags are case-insensitive in Obsidian search but preserve case

### Common Tags in Vault

Check existing notes to discover the user's tag vocabulary before inventing new tags. Match their style.

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

## Frontmatter

### Current Vault Policy

The existing vault does **NOT use YAML frontmatter**. Cortex MUST NOT add frontmatter to:

- Existing notes
- New notes (unless the user explicitly requests it)

This means:

- No `---` blocks at the top of notes
- Metadata is conveyed through inline `#tags`, note titles, and folder placement
- If the user later adopts frontmatter, this convention can be updated

## Folder Structure

### Current Vault Layout

```
C:\Projects\Notepad\
├── 00_Inbox/            # Capture zone — unprocessed notes
├── 10_Reflection/       # Personal reflections, journals
├── 20_Ideas/            # Ideas, concepts, project seeds
├── 30_People/           # Notes about specific people
├── 40_Reference/        # Reference material, how-tos
├── 99_System/           # System config, scripts
├── Job Hunt/            # Domain-specific (job search)
├── .obsidian/           # Obsidian config (DO NOT TOUCH)
├── .stfolder            # Syncthing marker
└── .stignore            # Syncthing ignore rules
```

### Folder Rules

- **NEVER** modify anything in `.obsidian/`
- **NEVER** modify `.stfolder` or `.stignore`
- Numbered prefixes (`00_`, `10_`, etc.) control sort order
- Cortex may suggest new folders (e.g., `50_Projects/`) but must get user confirmation
- When moving notes, update any `[[wikilinks]]` referencing the moved note in other files

## Moving Files

### When Cortex Moves a File

1. Read the file content
2. Write the file to the new location
3. Delete the file from the old location
4. Scan ALL other files in the vault for `[[wikilinks]]` that reference the moved file
5. Update those links if the filename changed (moves within the vault usually don't change the filename, so links stay valid)

### Important

- When Obsidian is running, it auto-updates links on rename. But Cortex can't rely on Obsidian being running.
- Link updates only matter if the **filename** changes (not the folder) — Obsidian resolves by filename, not path.
- If only the folder changes and the filename stays the same, no link updates are needed.

## File Writing

### Encoding

- UTF-8 (standard for Obsidian)
- Unix line endings (`\n`) preferred, but Windows (`\r\n`) is acceptable

### Syncthing Compatibility

- Changes are synced automatically — no special handling
- Avoid rapid sequential writes to the same file (Syncthing may conflict)
- After writing, the note is immediately visible in Obsidian (if open, it auto-refreshes)
