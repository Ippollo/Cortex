# Cortex Configuration

- **Vault Path**: c:\HQ\KB
- **Vault Name**: KB
- **Inbox Folder**: 00_Inbox
- **Daily Notes Folder**: 20_Journal
- **Default Tags**: (none)

## Vault Access

- **Method**: File-system tools exclusively (`view_file`, `grep_search`, `list_dir`, `write_to_file`)
- **Obsidian CLI**: Deprecated — do not use. See `c:\HQ\decisions.md` for rationale.
- **Read notes**: `view_file` with full path (`c:\HQ\KB\{folder}\{filename}.md`)
- **Search notes**: `grep_search` with `SearchPath="c:\HQ\KB\"`
- **List notes**: `list_dir` on vault folders
- **Create/edit notes**: `write_to_file` with full path
- **Move notes**: PowerShell `Move-Item` (no link updates needed — Obsidian resolves by filename)
