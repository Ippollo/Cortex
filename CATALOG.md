# Cortex Catalog

> Complete index of all workflows, agents, skills, and templates.
>
> **Requires**: Obsidian 1.12+ with [CLI enabled](https://help.obsidian.md/cli). All workflows use CLI commands to interact with the vault.

## Workflows

| Name             | File                                           | Description                                    |
| ---------------- | ---------------------------------------------- | ---------------------------------------------- |
| `/cx-capture`    | [cx-capture.md](workflows/cx-capture.md)       | Instant note capture to inbox                  |
| `/cx-inbox`      | [cx-inbox.md](workflows/cx-inbox.md)           | Process inbox — file, expand, connect, discard |
| `/cx-connect`    | [cx-connect.md](workflows/cx-connect.md)       | AI-suggested wikilinks between notes           |
| `/cx-synthesize` | [cx-synthesize.md](workflows/cx-synthesize.md) | Combine notes into insight notes               |
| `/cx-review`     | [cx-review.md](workflows/cx-review.md)         | Spaced repetition note surfacing               |
| `/cx-map`        | [cx-map.md](workflows/cx-map.md)               | Generate Maps of Content                       |
| `/cx-search`     | [cx-search.md](workflows/cx-search.md)         | Keyword + semantic vault search                |

## Agents

| Name        | File                                    | Role                                             |
| ----------- | --------------------------------------- | ------------------------------------------------ |
| Librarian   | [librarian.md](agents/librarian.md)     | Knowledge curator — files, organizes, connects   |
| Synthesizer | [synthesizer.md](agents/synthesizer.md) | Insight builder — combines notes, finds patterns |

## Skills

| Name                 | Path                                                          | Description                                       |
| -------------------- | ------------------------------------------------------------- | ------------------------------------------------- |
| PKM Methodology      | [pkm-methodology/](skills/pkm-methodology/SKILL.md)           | Zettelkasten, Progressive Summarization, MOCs     |
| Obsidian Conventions | [obsidian-conventions/](skills/obsidian-conventions/SKILL.md) | Wikilinks, tags, file naming, CLI commands (v2.0) |

## Templates

| Name       | File                                     | Used By                            |
| ---------- | ---------------------------------------- | ---------------------------------- |
| Fleeting   | [fleeting.md](templates/fleeting.md)     | `/cx-capture`                      |
| Permanent  | [permanent.md](templates/permanent.md)   | `/cx-inbox` (when upgrading)       |
| Literature | [literature.md](templates/literature.md) | Manual / `/cx-capture` with source |
| Synthesis  | [synthesis.md](templates/synthesis.md)   | `/cx-synthesize`                   |
| MOC        | [moc.md](templates/moc.md)               | `/cx-map`                          |
| Daily      | [daily.md](templates/daily.md)           | Obsidian daily notes                |
