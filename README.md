# 🧠 Cortex

**AI-powered knowledge management and productivity workflows for your Obsidian vault.**

Cortex is the thinking layer of your personal operating system. It eliminates the friction of capturing, connecting, and synthesizing knowledge — all from your IDE, no context-switching required.

## How It Works

```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                     │     │                     │     │                     │
│   Cortex            │────▶│   Obsidian Vault     │◀────│   Obsidian App      │
│   (AI Workflows)    │     │   (Markdown Files)   │     │   (UI & Sync)       │
│                     │     │                     │     │                     │
└─────────────────────┘     └─────────────────────┘     └─────────────────────┘
     You work here              Shared data layer            You browse here
```

- **Cortex** = AI workflows for capture, connection, synthesis, and review
- **Obsidian** = UI for browsing, graph view, mobile access, and sync
- **Your vault** = Plain markdown files shared by both tools

## Quick Start

1. **Clone this repo** into your projects folder:

   ```bash
   git clone https://github.com/YOUR_USERNAME/cortex.git C:\Projects\cortex
   ```

2. **Configure your vault** — edit `config.md`:

   ```markdown
   - **Vault Path**: C:\path\to\your\obsidian\vault
   ```

3. **Add to your IDE workspace** — add the `cortex/` folder alongside your vault folder

4. **Start capturing**:
   ```
   /capture "My first thought captured from Cortex"
   ```

## Workflows

| Workflow      | Priority | Purpose                                                    |
| ------------- | -------- | ---------------------------------------------------------- |
| `/cx-capture`    | P1       | Instant note capture to inbox — zero friction              |
| `/cx-inbox`      | P1       | Process captured notes — file, expand, connect, or discard |
| `/cx-connect`    | P2       | Find and add `[[wikilinks]]` between related notes         |
| `/cx-synthesize` | P2       | Combine notes into higher-level insights                   |
| `/cx-review`     | P2       | Surface forgotten notes for progressive review             |
| `/cx-map`        | P3       | Generate Maps of Content for topic navigation              |
| `/cx-daily`      | P3       | Create daily notes with reflection prompts                 |
| `/cx-search`     | P3       | Search vault by keyword + semantic matching                |

## Architecture

```
cortex/
├── config.md               # Vault path & preferences
├── workflows/              # The 8 workflows above
├── agents/
│   ├── librarian.md        # Files, organizes, connects notes
│   └── synthesizer.md      # Combines notes into insights
├── skills/
│   ├── pkm-methodology/    # Zettelkasten, Progressive Summarization, MOCs
│   └── obsidian-conventions/  # Wikilinks, tags, file naming, vault rules
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

- **Plain markdown** — every note is readable without any AI tool
- **AI-agnostic** — workflows are instructions, not code. Swap the AI engine without rebuilding
- **Obsidian-compatible** — `[[wikilinks]]`, `#tags`, no YAML frontmatter forced on existing notes
- **No lock-in** — your knowledge stays portable. Always.

## License

MIT
