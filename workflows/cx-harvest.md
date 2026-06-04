---
description: Sweep and harvest markdown artifacts from all Antigravity client directories into the Obsidian KB inbox.
quick_summary: "Harvest brain/ directories -> KB vault 00_Inbox with #ai-harvest tag."
requires_mcp: []
recommends_mcp: []
---

# /cx-harvest - Harvest Brain Artifacts

**Goal**: Automatically find, format, and copy AI-generated artifacts (research, designs, comparisons) from your various Antigravity clients (`antigravity`, `antigravity-ide`, `antigravity-cli`) into your Obsidian Knowledge Base.

## When to Use

- You switched clients temporarily (e.g., used the IDE or CLI) and want to pull specific artifacts back into your Obsidian vault.
- You want a one-off sweep of a specific client's brain directory after a productive session.
- **This is a manual tool.** Do not schedule it as an automatic cron. The preferred approach is intentional filing via `/cx-file-artifact` at the end of each valuable conversation.

## Steps

1. **Run the harvest script**:
   Execute the PowerShell script:
   ```powershell
   powershell -File c:\HQ\cortex\scripts\harvest_brains.ps1
   ```

2. **Verify imported files**:
   - Check `c:\HQ\KB\00_Inbox/` for any newly added notes.
   - Files will be prefixed/tagged with:
     - `tags: [ai-harvest]`
     - `ai_client: <client-name>`
     - `date: <today>`

3. **Run encoding validation gate** (required — do not skip):
   ```powershell
   powershell -File c:\HQ\cortex\scripts\validate-encoding.ps1 -Path "c:\HQ\KB\00_Inbox"
   ```
   - If exit code **0** → files are clean, proceed to Step 4.
   - If exit code **1** → encoding issues detected. Run the fixer before filing:
     ```powershell
     powershell -File c:\HQ\cortex\scripts\fix-encoding.ps1 -Path "c:\HQ\KB\00_Inbox" -Apply
     ```
   This prevents mojibake from being silently filed as corrupt content in the vault.

4. **Report results**:
   - List the files that were successfully harvested.
   - Note any encoding issues that were corrected.
   - Suggest running `/cx-connect` to link the new files to existing notes.
