# Cortex Configuration

> Conforms to the **KB Access Contract** (Option A). See
> `specwright/changes/hq-plugin-migration/kb-access-contract.md` for the full schema and the
> logical-location convention shared across all HQ plugins.

- **Vault Path** (`vault_root`): c:\HQ\KB
- **Vault Name**: KB
- **Inbox Folder**: 00_Inbox
- **Daily Notes Folder**: 20_Journal
- **Default Tags**: (none)
- **Access Method** (`access_method`): filesystem  <!-- future: kb-mcp (Option B) -->

> **`{vault_root}` token.** Commands and skills refer to the vault as `{vault_root}` and never
> hardcode an absolute path. Resolve it to the **Vault Path** value above. This line is the
> **single** place the machine-specific path lives — change it here to point the whole plugin at a
> different vault (or run `cowork-plugin-customizer` when sharing).
>
> **`{plugin_root}` token.** Commands refer to this plugin's own bundled files (e.g.
> `{plugin_root}\scripts\harvest_brains.ps1`) relative to the plugin's install directory — never
> an absolute install path. When installed, this is the plugin's root (Claude Code exposes it as
> `${CLAUDE_PLUGIN_ROOT}`; **verify the exact variable at install-test, T13**). Pre-install, it
> resolves to the `cortex/` directory.

## Logical Folder Map

Skills reference logical names; the contract resolves them to folders under `vault_root`.
Sub-locations use `/` (e.g. `{knowledge}/jobs` → `40_Knowledge/jobs`).

| Logical | Folder | Writable |
|---|---|---|
| `inbox` | `00_Inbox` | yes |
| `projects` | `10_Projects` | yes |
| `journal` | `20_Journal` | **read-only** |
| `ideas` | `30_Ideas` | yes |
| `knowledge` | `40_Knowledge` | yes |
| `finance` | `50_Finance` | **read-only** |
| `system` | `99_System` | yes |

## Read-Only Zones

- **`read_only`**: `20_Journal`, `50_Finance`
- **Reads** are always allowed.
- **Writes are forbidden by default** — a skill must never write to these folders on its own
  initiative. The **only** exception is **explicit user instruction**: the destination is shown to
  the user and approved first (per `KB/99_System/vault-manual.md`).
- When presenting proposed actions for approval, mark any read-only destination with `🔒` so it
  cannot be rubber-stamped inside a batch.
- Approval is per-operation, per-session — it never carries forward.

  (Convention-enforced under Option A; becomes code-enforced under the future KB MCP.)

## Vault Access

- **Method**: File-system tools exclusively (`view_file`, `grep_search`, `list_dir`, `write_to_file`)
- **Obsidian CLI**: Deprecated — do not use. See `{vault_root}\99_System\decisions.md` for rationale.
- **Read notes**: `view_file` with full path (`{vault_root}\{folder}\{filename}.md`)
- **Search notes**: `grep_search` with `SearchPath="{vault_root}\"`
- **List notes**: `list_dir` on vault folders
- **Create/edit notes**: `write_to_file` with full path
- **Move notes**: PowerShell `Move-Item` (no link updates needed — Obsidian resolves by filename)
