---
name: vault-search
description: Find notes in the KB vault from natural language — "find my notes about X", "what did I write on Y", "search my vault for Z", "do I have a note on…". The model-invocable entry point to vault search; use it whenever the user wants to locate existing notes by concept, question, or keyword.
---

# Vault Search

The natural-language entry point to the KB vault. When the user asks to find, recall, or locate
something they've written — without typing an explicit command — run this.

> This is the model-invocable twin of the `/cx-search` command (distinct name so it never
> shadows the command). It follows the **same procedure**; the command is the source of truth.

## What to do

Execute the `cx-search` procedure (`../../commands/cx-search.md`) against the vault:

1. **Parse the query** from what the user said (a concept, a question, or a name).
2. **Search the vault** using file-system tools under the vault root (see `config.md` →
   `vault_root`): full-text (keyword) first, then tag matches, then AI-semantic matches for
   concepts without exact keyword overlap.
3. **Rank**: exact title → tag → content → AI-suggested (flag the last as AI-suggested).
4. **Present** grouped results with a one-line preview each; offer to open one.
5. **On selection**, read and display the full note.

## Principles

- **Fast first, smart second** — show keyword hits immediately, layer AI results after.
- **Preview, don't overwhelm** — first sentence, not full content.
- **Zero results is useful** — "no notes found" means it's safe to create one (`/cx-capture`).
- **Reads only** — search never writes; it honors the read-only zones like everything else.

## When NOT to use

- The user typed an explicit `/cx-search` (the command handles it).
- The user wants to *create*, *connect*, or *synthesize* notes → those are `/cx-capture`,
  `/cx-connect`, `/cx-synthesize`.
