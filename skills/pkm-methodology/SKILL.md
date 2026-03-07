---
name: PKM Methodology
description: Personal Knowledge Management principles — Zettelkasten, Progressive Summarization, Maps of Content. Loaded when agents need to make decisions about note quality, filing, or knowledge structure.
version: 1.0.0
triggers:
  - knowledge management
  - note quality
  - zettelkasten
  - filing decisions
  - note types
---

# PKM Methodology

A reference for AI agents making knowledge management decisions. Use these principles to guide note creation, filing, connection, and review workflows.

## Zettelkasten Principles

### Note Types

| Type           | Purpose                              | Lifecycle                          | Template        |
| -------------- | ------------------------------------ | ---------------------------------- | --------------- |
| **Fleeting**   | Quick capture, raw thought           | Temporary — process within 24-48h  | `fleeting.md`   |
| **Literature** | Key takeaways from a source          | Semi-permanent — in your own words | `literature.md` |
| **Permanent**  | Atomic, refined idea                 | Long-lived — stands on its own     | `permanent.md`  |
| **Synthesis**  | Combined insight from multiple notes | Long-lived — links to sources      | `synthesis.md`  |

### Atomic Notes

- One idea per note
- The note should be understandable without reading any linked notes
- If a note covers two ideas, split it into two notes
- A good test: can you give this note a clear, specific title?

### Connections Over Categories

- Where you file a note matters less than what it connects to
- A note with 5 `[[wikilinks]]` in the right folder is better than a perfectly filed note with zero links
- When suggesting connections, prioritize notes that share concepts, not just topics

### Write in Your Own Words

- Literature notes should paraphrase, not quote
- Permanent notes should express YOUR insight, not someone else's
- If you can't rewrite it in your own words, you don't understand it yet

## Progressive Summarization

### Layer Model

When reviewing notes, apply progressive distillation:

1. **Layer 0**: Original captured text
2. **Layer 1**: Bold the key sentences (on first review)
3. **Layer 2**: Highlight within the bold (on second review)
4. **Layer 3**: Write an executive summary at the top (when the note becomes important)
5. **Layer 4**: Remix into your own work (synthesis, blog post, project)

### Review Heuristic

- Don't distill everything — only distill when you encounter a note and need it
- The act of distilling IS the learning
- Most notes will stay at Layer 0 and that's fine

## Maps of Content (MOCs)

### When to Create

- A topic has **5+ notes** and browsing becomes unwieldy
- You find yourself thinking "I know I wrote about this somewhere"
- You want to introduce someone (or future-you) to a topic

### Structure

- A MOC is just a regular note with curated `[[wikilinks]]`
- Group links by subtopic with brief descriptions
- Include an "Overview" section explaining the topic
- MOCs can link to other MOCs (nested navigation)

### Maintenance

- MOCs should be updated when new notes on the topic are created
- Stale MOCs are worse than no MOC — flag for review if outdated

## Filing Heuristics

When deciding where to file a note, use these guidelines:

| Content Type                       | Suggested Folder | Reasoning        |
| ---------------------------------- | ---------------- | ---------------- |
| Raw capture, unsorted thought      | `00_Inbox`       | Needs processing |
| Personal reflection, journal entry | `10_Reflection`  | Self-oriented    |
| Business idea, project concept     | `20_Ideas`       | Forward-looking  |
| Notes about a specific person      | `30_People`      | Person-focused   |
| Reference material, how-tos        | `40_Reference`   | Backward-looking |

**Important**: These are defaults based on the current vault. The user may have custom folders. Always present the suggestion and let the user confirm or redirect.

## Note Quality Checklist

When helping refine a note (during `/cx-inbox` or `/cx-connect`):

- [ ] Does it have a clear, specific title?
- [ ] Is the content atomic (one idea)?
- [ ] Is it written in the user's own words (not raw quotes)?
- [ ] Does it have relevant `#tags`?
- [ ] Are there `[[wikilinks]]` to related notes?
- [ ] Would future-you understand this without additional context?
