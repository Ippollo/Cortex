# 🧠 Cortex

**AI-powered knowledge management and productivity workflows for your Obsidian vault.**

Cortex is the thinking layer of your personal operating system. It eliminates the friction of capturing, connecting, and synthesizing knowledge — all from your IDE, no context-switching required.

## Prerequisites

- **Obsidian 1.12+** with the [CLI enabled](https://help.obsidian.md/cli)
- Obsidian desktop app running (CLI connects to the running instance)
- Cortex and Obsidian vault added to your IDE workspace

## How It Works

```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                     │     │                     │     │                     │
│   Cortex            │────▶│   Obsidian Vault     │◀────│   Obsidian App      │
│   (AI Workflows)    │     │   (Markdown Files)   │     │   (UI & Sync)       │
│                     │     │                     │     │                     │
└────────┬────────────┘     └─────────────────────┘     └────────┬────────────┘
         │                                                       │
         └───────────────── Obsidian CLI ───────────────────────┘
                        (shared command interface)
```

- **Cortex** = AI workflows for capture, connection, synthesis, and review
- **Obsidian CLI** = Command-line bridge — Cortex uses it to interact with Obsidian's link graph, search index, and template engine
- **Obsidian** = UI for browsing, graph view, mobile access, and sync
- **Your vault** = Plain markdown files shared by all tools

## Quick Start

1. **Clone this repo** into your projects folder:

   ```bash
   git clone https://github.com/Ippollo/cortex.git C:\Projects\cortex
   ```

2. **Configure your vault** — edit `config.md`:

   ```markdown
   - **Vault Path**: C:\path\to\your\obsidian\vault
   - **Vault Name**: YourVaultName
   ```

3. **Enable Obsidian CLI** — in Obsidian: Settings → General → enable "Command line interface"

4. **Verify CLI** — in your terminal:

   ```bash
   obsidian version
   obsidian vault
   ```

5. **Add to your IDE workspace** — add the `cortex/` folder alongside your vault folder

6. **Start capturing**:
   ```
   /cx-capture "My first thought captured from Cortex"
   ```

## Workflows

| Workflow         | Priority | Purpose                                                    |
| ---------------- | -------- | ---------------------------------------------------------- |
| `/cx-capture`    | P1       | Instant note capture to inbox — zero friction              |
| `/cx-inbox`      | P1       | Process captured notes — file, expand, connect, or discard |
| `/cx-connect`    | P2       | Find and add `[[wikilinks]]` between related notes         |
| `/cx-synthesize` | P2       | Combine notes into higher-level insights                   |
| `/cx-review`     | P2       | Surface forgotten notes for progressive review             |
| `/cx-map`        | P3       | Generate Maps of Content for topic navigation              |
| `/cx-search`     | P3       | Search vault by keyword + semantic matching                |

## Architecture

```
cortex/
├── config.md               # Vault path, CLI config & preferences
├── workflows/              # The 7 workflows above
├── agents/
│   ├── librarian.md        # Files, organizes, connects notes
│   └── synthesizer.md      # Combines notes into insights
├── skills/
│   ├── pkm-methodology/    # Zettelkasten, Progressive Summarization, MOCs
│   └── obsidian-conventions/  # Wikilinks, tags, file naming, CLI commands
├── templates/
│   ├── fleeting.md         # Quick capture
│   ├── permanent.md        # Refined atomic note
│   ├── literature.md       # Source/reading notes
│   ├── synthesis.md        # Combined insights
│   ├── moc.md              # Map of Content
│   └── daily.md            # Daily journal
├── README.md
└── CATALOG.md
```

## Design Principles

- **CLI-first** — workflows use Obsidian CLI to leverage the link graph, search index, and template engine
- **Plain markdown** — every note is readable without any AI tool
- **AI-agnostic** — workflows are instructions, not code. Swap the AI engine without rebuilding
- **Obsidian-compatible** — `[[wikilinks]]`, `#tags`, no YAML frontmatter forced on existing notes
- **No lock-in** — your knowledge stays portable. Always.

## License

MIT
